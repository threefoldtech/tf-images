#!/bin/bash

# Error handling
set -eE
trap 'error_handler $? $LINENO $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]:-})' ERR

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
WORK_DIR="ubuntu-noble"
ARCHIVE_NAME="ubuntu-24.04_fullvm_oi.tar.gz"
LOG_FILE="/var/log/flist-builder.log"

# Helper functions
log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}[${timestamp}] ${1}${NC}" | tee -a "$LOG_FILE"
}

warn() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${YELLOW}[${timestamp}] WARNING: ${1}${NC}" | tee -a "$LOG_FILE"
}

error() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${RED}[${timestamp}] ERROR: ${1}${NC}" | tee -a "$LOG_FILE"
}

error_handler() {
    local exit_code=$1
    local line_no=$2
    local bash_lineno=$3
    local last_command=$4
    local func_stack=$5
    
    error "Exit code $exit_code occurred on line $line_no while executing: $last_command"
    error "Function stack: $func_stack"
    
    cleanup
}

cleanup() {
    log "Performing cleanup..."
    if [ -d "$WORK_DIR" ]; then
        rm -rf "$WORK_DIR"
    fi
    exit 1
}

check_requirements() {
    log "Checking requirements..."
    
    # Check if running as root
    if [ "$(id -u)" -ne 0 ]; then
        error "This script must be run as root"
        exit 1
    fi
    
    # Check for API key
    if [ -z "$1" ]; then
        error "Usage: $0 <API_KEY>"
        exit 2
    fi
    
    # Check for required files
    local required_files=("gpu-setup.sh" "start-containers.sh")
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            error "Required file $file not found!"
            exit 1
        fi
    done
    
    # Check for required tools
    local required_tools=("curl" "tar" "arch-install-scripts" "debootstrap")
    for tool in "${required_tools[@]}"; do
        if ! command -v $tool &>/dev/null; then
            log "Installing $tool..."
            apt-get update && apt-get install -y $tool
        fi
    done
}

setup_chroot() {
    log "Setting up chroot environment..."
    
    # Create work directory
    mkdir -p "$WORK_DIR"
    
    # Run debootstrap
    log "Running debootstrap for Ubuntu Noble..."
    if ! debootstrap noble "$WORK_DIR" http://archive.ubuntu.com/ubuntu; then
        error "Debootstrap failed!"
        exit 1
    fi
    
    # Copy required scripts
    log "Copying required scripts to chroot environment..."
    cp gpu-setup.sh "$WORK_DIR/root/"
    cp start-containers.sh "$WORK_DIR/root/"
    
    # Create setup script
    log "Creating chroot setup script..."
    cat > "$WORK_DIR/root/setup_inside_chroot.sh" <<'EOF'
#!/bin/bash
set -e

# Setup basic configuration
export PATH=/usr/local/sbin/:/usr/local/bin/:/usr/sbin/:/usr/bin/:/sbin:/bin
rm -f /etc/resolv.conf
echo 'nameserver 1.1.1.1' > /etc/resolv.conf
echo "ubuntu-noble" > /etc/hostname

# Update and install packages
apt-get update
apt-get install -y cloud-init openssh-server curl initramfs-tools wget pciutils build-essential software-properties-common gnupg

# Set script permissions
chmod +x /root/gpu-setup.sh
chmod +x /root/start-containers.sh

# Create GPU setup service
cat > /etc/systemd/system/gpu-setup.service <<'SERVICEEOF'
[Unit]
Description=GPU Setup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/root/gpu-setup.sh

[Install]
WantedBy=multi-user.target
SERVICEEOF

# Create container start service
cat > /etc/systemd/system/start-containers.service <<'SERVICEEOF'
[Unit]
Description=Start Docker Containers
After=gpu-setup.service

[Service]
Type=oneshot
ExecStart=/root/start-containers.sh

[Install]
WantedBy=multi-user.target
SERVICEEOF

# Enable services
systemctl daemon-reload
systemctl enable gpu-setup.service
systemctl enable start-containers.service

# Configure system
cloud-init clean
apt-get install -y linux-image-6.8.0-31-generic
echo 'fs-virtiofs' >> /etc/initramfs-tools/modules
update-initramfs -c -k all
update-grub
apt-get clean
EOF
    
    chmod +x "$WORK_DIR/root/setup_inside_chroot.sh"
}

run_chroot_setup() {
    log "Running chroot setup..."
    if ! arch-chroot "$WORK_DIR" /root/setup_inside_chroot.sh; then
        error "Chroot setup failed!"
        exit 1
    fi
    
    # Cleanup chroot
    log "Cleaning up chroot environment..."
    rm "$WORK_DIR/root/setup_inside_chroot.sh"
    rm -rf "$WORK_DIR/dev/*"
}

extract_kernel() {
    log "Setting up kernel extraction..."
    
    # Install extract-vmlinux if needed
    if ! command -v extract-vmlinux &>/dev/null; then
        log "Installing extract-vmlinux..."
        curl -o /usr/local/bin/extract-vmlinux \
            https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux
        chmod +x /usr/local/bin/extract-vmlinux
    fi
    
    log "Extracting kernel..."
    if ! extract-vmlinux "$WORK_DIR/boot/vmlinuz" | \
        tee "$WORK_DIR/boot/vmlinuz-6.8.0-31-generic.elf" > /dev/null; then
        error "Kernel extraction failed!"
        exit 1
    fi
    
    mv "$WORK_DIR/boot/vmlinuz-6.8.0-31-generic.elf" \
        "$WORK_DIR/boot/vmlinuz-6.8.0-31-generic"
}

create_archive() {
    log "Creating compressed archive..."
    if ! tar -czf "$ARCHIVE_NAME" -C "$WORK_DIR" .; then
        error "Archive creation failed!"
        exit 1
    fi
}

upload_flist() {
    local API_KEY="$1"
    log "Uploading to hub.grid.tf..."
    
    local response
    response=$(curl -X POST -H "Authorization: Bearer $API_KEY" \
        -F "file=@$ARCHIVE_NAME" \
        https://hub.grid.tf/api/flist/me/upload)
    
    if [ $? -ne 0 ]; then
        error "Upload failed!"
        error "Response: $response"
        exit 1
    fi
    
    log "Upload completed successfully!"
    log "Response: $response"
}

main() {
    local API_KEY="$1"
    
    # Initialize log file
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
    
    log "Starting flist builder for Ubuntu 24.04..."
    
    check_requirements "$API_KEY"
    setup_chroot
    run_chroot_setup
    extract_kernel
    create_archive
    upload_flist "$API_KEY"
    
    log "Flist creation completed successfully!"
    
    # Cleanup
    rm -rf "$WORK_DIR"
    rm -f "$ARCHIVE_NAME"
}

# Execute main function
main "$1"