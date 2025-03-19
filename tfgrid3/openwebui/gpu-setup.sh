#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log() { echo -e "${GREEN}[SETUP]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    error "This script must be run as root"
fi

# Install prerequisites and dependencies
install_dependencies() {
    log "Installing prerequisites and dependencies..."

    # Update package lists
    apt update || error "Failed to update package lists"

    # Essential packages needed for GPU detection and setup
    PACKAGES=(
        "wget"
        "curl"
        "pciutils"
        "build-essential"
        "software-properties-common"
        "linux-headers-$(uname -r)"
    )

    # Install packages
    for package in "${PACKAGES[@]}"; do
        if ! dpkg -l | grep -q "^ii.*$package"; then
            log "Installing $package..."
            apt install -y "$package" || warn "Failed to install $package"
        else
            log "$package is already installed"
        fi
    done

    # Install Docker if not present
    if ! command -v docker &>/dev/null; then
        log "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        systemctl enable --now docker
    fi
}

# Detect GPU type
detect_gpu_type() {
    if lspci | grep -i "nvidia" > /dev/null; then
        echo "nvidia"
    elif lspci | grep -i "AMD\|Radeon" > /dev/null; then
        echo "amd"
    else
        echo "unknown"
    fi
}

# Setup NVIDIA
setup_nvidia() {
    log "Setting up NVIDIA GPU environment..."

    # Install NVIDIA drivers if not present
    if ! command -v nvidia-smi &>/dev/null; then
        log "Installing NVIDIA drivers using ubuntu-drivers autoinstall..."
        apt install -y ubuntu-drivers-common
        ubuntu-drivers autoinstall

        # Check if nvidia-smi is available after autoinstall
        if ! command -v nvidia-smi &>/dev/null; then
            log "Autoinstall didn't provide nvidia-smi, installing specific driver 535..."
            add-apt-repository -y ppa:graphics-drivers/ppa
            apt update
            apt install -y nvidia-driver-535 nvidia-utils-535
        fi
    fi

    # Setup NVIDIA Container Toolkit
    log "Setting up NVIDIA Container Toolkit..."
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    apt update
    apt install -y nvidia-container-toolkit
    nvidia-ctk runtime configure --runtime=docker

    # Configure Docker for NVIDIA runtime
    log "Configuring Docker for NVIDIA runtime..."
    mkdir -p /etc/docker
    cat > /etc/docker/daemon.json <<EOF
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF

    # Restart Docker
    systemctl restart docker
    sleep 5

    # Final check for nvidia-smi
    if ! command -v nvidia-smi &>/dev/null; then
        warn "nvidia-smi still not available after driver installation!"
        warn "This may require a system reboot to fully activate drivers"
    else
        log "NVIDIA drivers successfully installed and nvidia-smi is available"
    fi

    # Install CUDA if not present
    if ! command -v nvcc &>/dev/null; then
        log "Installing CUDA toolkit..."
        apt install -y nvidia-cuda-toolkit
    fi
}

# Setup AMD
setup_amd() {
    log "Setting up AMD GPU environment..."

    # Install AMD GPU drivers and tools
    apt install -y \
        linux-headers-generic \
        clinfo

    # Add ROCm repository if needed
    if [ ! -f /etc/apt/sources.list.d/rocm.list ]; then
        log "Adding ROCm repository..."
        wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | apt-key add -
        echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/5.7 ubuntu main' | tee /etc/apt/sources.list.d/rocm.list
        apt update
    fi

    # Install ROCm packages
    apt install -y \
        rocm-hip-sdk \
        rocm-hip-runtime \
        rocm-opencl-runtime \
        rocm-hip-libraries \
        rocm-dev \
        rocm-utils \
        hip-runtime-amd

    # Add user to video group if SUDO_USER is available
    if [ -n "$SUDO_USER" ]; then
        usermod -a -G video "$SUDO_USER"
        log "Added user $SUDO_USER to video group"
    fi

    # Set up environment variables
    if [ ! -f /etc/profile.d/rocm.sh ]; then
        echo 'export PATH=$PATH:/opt/rocm/bin:/opt/rocm/rocprofiler/bin:/opt/rocm/opencl/bin' > /etc/profile.d/rocm.sh
        echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rocm/lib:/opt/rocm/lib64' >> /etc/profile.d/rocm.sh
        chmod 644 /etc/profile.d/rocm.sh
    fi
}

# Main function
main() {
    log "Starting GPU setup..."

    # Install dependencies first
    install_dependencies

    # Setup based on GPU type
    GPU_TYPE=$(detect_gpu_type)
    case $GPU_TYPE in
        "nvidia")
            setup_nvidia
            ;;
        "amd")
            setup_amd
            ;;
        *)
            error "No supported GPU detected (NVIDIA or AMD required)"
            ;;
    esac

    systemctl disable gpu-setup.service

    log "GPU setup completed successfully!"
}

# Execute main function
main
