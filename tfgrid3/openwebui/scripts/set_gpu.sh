#!/bin/bash

# Unified GPU Setup Script for Ubuntu (NVIDIA & AMD)
# License: Apache 2.0

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Get script name dynamically
SCRIPT_PATH="$0"
SCRIPT_NAME=$(basename "$SCRIPT_PATH")
INSTALL_NAME=$(basename "$SCRIPT_NAME" .sh)

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
LOG_DIR="/var/log/${INSTALL_NAME}"
INSTALL_LOG="${LOG_DIR}/install.log"

# Version
VERSION="0.2.0"

# Helper Functions
log() {
    echo -e "${GREEN}[SETUP]${NC} $1"
    if [ -w "$INSTALL_LOG" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$INSTALL_LOG"
    fi
    sleep 1
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    if [ -w "$INSTALL_LOG" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1" >> "$INSTALL_LOG"
    fi
    sleep 1
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    if [ -w "$INSTALL_LOG" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$INSTALL_LOG"
    fi
    sleep 1
    exit 1
}

setup_logging() {
    mkdir -p "$LOG_DIR" || error "Failed to create log directory"
    touch "$INSTALL_LOG" || error "Failed to create log file"
    chmod 755 "$LOG_DIR" || error "Failed to set log directory permissions"
    chmod 644 "$INSTALL_LOG" || error "Failed to set log file permissions"
}

show_logs() {
    if [ ! -f "$INSTALL_LOG" ]; then
        echo -e "${YELLOW}No logs found at: $INSTALL_LOG${NC}"
        return 1
    fi

    echo -e "${BLUE}===== Log File Contents ($INSTALL_LOG) =====${NC}"
    echo -e "${BLUE}Last modified: $(stat -c %y "$INSTALL_LOG")${NC}"
    echo -e "${BLUE}File size: $(du -h "$INSTALL_LOG" | cut -f1)${NC}"
    echo -e "${BLUE}============================================${NC}\n"

    if command -v less &> /dev/null; then
        less -R "$INSTALL_LOG"
    else
        cat "$INSTALL_LOG"
    fi
}

show_recent_logs() {
    local lines=${1:-50}
    
    if [ ! -f "$INSTALL_LOG" ]; then
        echo -e "${YELLOW}No logs found at: $INSTALL_LOG${NC}"
        return 1
    fi

    echo -e "${BLUE}===== Recent Logs (Last $lines lines) =====${NC}"
    echo -e "${BLUE}Last modified: $(stat -c %y "$INSTALL_LOG")${NC}"
    echo -e "${BLUE}============================================${NC}\n"

    tail -n "$lines" "$INSTALL_LOG"
}

delete_logs() {
    echo -e "${YELLOW}Deleting logs...${NC}"
    if [ -d "$LOG_DIR" ]; then
        if ! rm -rf "$LOG_DIR"; then
            error "Failed to delete log directory: $LOG_DIR"
        fi
        echo -e "${GREEN}Successfully deleted log directory: $LOG_DIR${NC}"
    else
        echo -e "${YELLOW}Log directory does not exist: $LOG_DIR${NC}"
    fi
}

detect_gpu_type() {
    if lspci | grep -i "nvidia" > /dev/null; then
        echo "nvidia"
    elif lspci | grep -i "AMD\|Radeon" > /dev/null; then
        echo "amd"
    else
        echo "unknown"
    fi
}

install_prerequisites_and_dependencies() {
    if ! grep -q "Ubuntu" /etc/os-release; then
        warn "This script is designed for Ubuntu. Other distributions may not work correctly."
    fi

    log "Updating package lists..."
    if ! apt update; then
        error "Failed to update package lists"
    fi

    # Common packages that should be installed first
    local COMMON_PACKAGES=(
        "wget"
        "curl"
        "pciutils"
        "build-essential"
        "software-properties-common"
        "linux-headers-$(uname -r)"
    )

    # Install common packages first
    for package in "${COMMON_PACKAGES[@]}"; do
        if ! dpkg -l | grep -q "^ii.*$package"; then
            log "Installing $package..."
            if ! apt install -y "$package"; then
                warn "Failed to install $package"
            fi
        else
            log "$package is already installed"
        fi
    done

    # After common packages are installed, check GPU type and install specific packages
    local GPU_TYPE=$(detect_gpu_type)
    local GPU_PACKAGES=()
    
    case $GPU_TYPE in
        "nvidia")
            GPU_PACKAGES+=(
                "ubuntu-drivers-common"
                "dkms"
            )
            ;;
        "amd")
            GPU_PACKAGES+=(
                "clinfo"
            )
            ;;
    esac

    # Install GPU-specific packages
    for package in "${GPU_PACKAGES[@]}"; do
        if ! dpkg -l | grep -q "^ii.*$package"; then
            log "Installing $package..."
            if ! apt install -y "$package"; then
                warn "Failed to install $package"
            fi
        else
            log "$package is already installed"
        fi
    done

    if [ "${PERFORM_UPGRADE:-false}" = true ]; then
        log "Performing system upgrade..."
        if ! apt upgrade -y; then
            warn "Package upgrade failed, continuing anyway..."
        fi
    fi
}

setup_nvidia_gpu() {
    log "NVIDIA GPU detected. Checking current setup..."
    
    # First ensure ubuntu-drivers-common is installed
    if ! command -v ubuntu-drivers &>/dev/null; then
        log "Installing ubuntu-drivers-common package..."
        if ! apt-get install -y ubuntu-drivers-common; then
            error "Failed to install ubuntu-drivers-common"
        fi
    fi
    
    # Check current driver status
    if nvidia-smi &>/dev/null; then
        CURRENT_DRIVER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
        log "NVIDIA drivers are already installed (Version: $CURRENT_DRIVER)"
    else
        log "Installing NVIDIA drivers..."
        if ! ubuntu-drivers autoinstall; then
            error "Failed to install NVIDIA drivers"
        fi
        log "Drivers installed. A system restart will be required."
    fi

    # Check CUDA installation
    if ! command -v nvcc &>/dev/null; then
        log "Installing CUDA toolkit..."
        if ! apt install -y nvidia-cuda-toolkit; then
            error "Failed to install CUDA toolkit"
        fi
        CUDA_VERSION=$(nvcc --version | grep "release" | awk '{print $5}' | sed 's/,//')
        log "CUDA toolkit installed (Version: $CUDA_VERSION)"
    else
        CUDA_VERSION=$(nvcc --version | grep "release" | awk '{print $5}' | sed 's/,//')
        log "CUDA toolkit is already installed (Version: $CUDA_VERSION)"
    fi
}

setup_amd_gpu() {
    log "AMD GPU detected. Checking current setup..."

    # Check for existing AMD drivers
    if lsmod | grep -q amdgpu; then
        CURRENT_DRIVER=$(modinfo amdgpu | grep version | awk '{print $2}')
        log "AMDGPU drivers are loaded (Version: $CURRENT_DRIVER)"
    else
        log "Installing AMDGPU drivers..."
        
        # Install required packages
        local REQUIRED_PACKAGES=(
            "linux-headers-generic"
            "wget"
            "gnupg2"
        )
        
        for package in "${REQUIRED_PACKAGES[@]}"; do
            if ! dpkg -l | grep -q "^ii.*$package"; then
                log "Installing $package..."
                if ! apt install -y "$package"; then
                    error "Failed to install $package"
                fi
            fi
        done

        # Add ROCm repository
        log "Adding ROCm repository..."
        if ! wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | apt-key add -; then
            error "Failed to add ROCm GPG key"
        fi

        # Detect Ubuntu version
        UBUNTU_VERSION=$(lsb_release -rs)
        # Choose appropriate ROCm version based on Ubuntu version
        case $UBUNTU_VERSION in
            20.04|22.04)
                ROCM_VERSION="5.7"  # Latest stable for Ubuntu 20.04/22.04
                ;;
            *)
                warn "Untested Ubuntu version: $UBUNTU_VERSION. Using latest ROCm version."
                ROCM_VERSION="5.7"
                ;;
        esac

        # Add repository
        echo "deb [arch=amd64] https://repo.radeon.com/rocm/apt/${ROCM_VERSION} ubuntu main" | \
            tee /etc/apt/sources.list.d/rocm.list

        # Update package lists
        if ! apt update; then
            error "Failed to update package lists after adding ROCm repository"
        fi

        # Install ROCm packages
        log "Installing ROCm packages..."
        local ROCM_PACKAGES=(
            "rocm-hip-libraries"
            "rocm-dev"
            "rocm-utils"
            "rocm-hip-sdk"
            "hip-runtime-amd"
        )

        for package in "${ROCM_PACKAGES[@]}"; do
            if ! apt install -y "$package"; then
                warn "Failed to install $package"
            fi
        done
    fi

    # Check ROCm installation
    if ! command -v rocm-smi &>/dev/null; then
        log "Installing ROCm tools..."
        if ! apt install -y rocm-smi; then
            error "Failed to install ROCm tools"
        fi
        
        # Add user to video group
        if [ -n "$SUDO_USER" ]; then
            usermod -a -G video "$SUDO_USER"
            log "Added user $SUDO_USER to video group"
        fi

        # Set up environment variables
        if [ ! -f /etc/profile.d/rocm.sh ]; then
            echo 'export PATH=$PATH:/opt/rocm/bin:/opt/rocm/rocprofiler/bin:/opt/rocm/opencl/bin' > /etc/profile.d/rocm.sh
            echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rocm/lib:/opt/rocm/lib64' >> /etc/profile.d/rocm.sh
            chmod 644 /etc/profile.d/rocm.sh
            log "Added ROCm environment variables"
        fi

        ROCM_VERSION=$(rocm-smi --version 2>/dev/null || echo "unknown")
        log "ROCm tools installed (Version: $ROCM_VERSION)"
    else
        ROCM_VERSION=$(rocm-smi --version 2>/dev/null || echo "unknown")
        log "ROCm is already installed (Version: $ROCM_VERSION)"
    fi

    # Verify installation
    log "Verifying ROCm installation..."
    if ! rocm-smi --showdriverversion &>/dev/null; then
        warn "ROCm installation might not be complete. A system restart may be required."
    else
        log "ROCm installation verified successfully"
    fi
}

setup_gpu() {
    log "Detecting GPU type..."
    GPU_TYPE=$(detect_gpu_type)
    
    case $GPU_TYPE in
        "nvidia")
            setup_nvidia_gpu
            ;;
        "amd")
            setup_amd_gpu
            ;;
        *)
            error "No supported GPU detected (NVIDIA or AMD required)"
            ;;
    esac
}

show_nvidia_info() {
    echo -e "\n${GREEN}GPU Hardware Details:${NC}"
    lspci | grep -i nvidia
    
    echo -e "\n${GREEN}NVIDIA Driver Details:${NC}"
    if nvidia-smi &>/dev/null; then
        nvidia-smi
    else
        echo "NVIDIA drivers not loaded"
    fi
    
    echo -e "\n${GREEN}CUDA Version:${NC}"
    if command -v nvcc &>/dev/null; then
        nvcc --version
    else
        echo "CUDA not installed"
    fi
}

show_amd_info() {
    echo -e "\n${GREEN}GPU Hardware Details:${NC}"
    lspci | grep -i "AMD\|Radeon"
    
    echo -e "\n${GREEN}AMD Driver Details:${NC}"
    if lsmod | grep -q amdgpu; then
        modinfo amdgpu | grep -E 'version|description'
        echo -e "\n${GREEN}ROCm Version:${NC}"
        rocm-smi --version
    else
        echo "AMDGPU drivers not loaded"
    fi
    
    echo -e "\n${GREEN}Compute Devices:${NC}"
    clinfo 2>/dev/null | grep -E 'Platform Name|Device Name' || echo "No OpenCL devices found"
}

show_gpu_info() {
    echo -e "\n${BLUE}===== GPU Information =====${NC}"
    
    GPU_TYPE=$(detect_gpu_type)
    case $GPU_TYPE in
        "nvidia")
            show_nvidia_info
            ;;
        "amd")
            show_amd_info
            ;;
        *)
            echo "No supported GPU detected"
            ;;
    esac
}

install() {
    echo -e "${GREEN}Installing ${INSTALL_NAME} v${VERSION}...${NC}"
    
    rm -f "/usr/local/bin/${INSTALL_NAME}"
    
    if ! cp "$SCRIPT_PATH" "/usr/local/bin/${INSTALL_NAME}"; then
        error "Failed to copy script to /usr/local/bin"
    fi

    if ! chmod 755 "/usr/local/bin/${INSTALL_NAME}"; then
        error "Failed to set script permissions"
    fi

    mkdir -p "$LOG_DIR"
    chmod 755 "$LOG_DIR"

    echo -e "\n${PURPLE}${INSTALL_NAME} v${VERSION} has been installed successfully.${NC}"
    echo -e "\nTo see available commands, run: ${BLUE}${INSTALL_NAME} help${NC}"
}

uninstall() {
    echo -e "${GREEN}Uninstalling ${INSTALL_NAME}...${NC}"
    
    if ! rm -f "/usr/local/bin/${INSTALL_NAME}"; then
        error "Failed to remove script from /usr/local/bin"
    fi
    
    delete_logs
    
    echo -e "${GREEN}Uninstallation completed successfully.${NC}"
}

show_status() {
    clear
    echo -e
    echo -e "${BLUE}===== GPU Status (${INSTALL_NAME} v${VERSION}) =====${NC}"
    echo -e
    show_gpu_info
}

show_version() {
    echo -e "${BLUE}${INSTALL_NAME} v${VERSION}${NC}"
}

show_help() {
    echo -e
    echo -e "${BLUE}===== ${INSTALL_NAME} v${VERSION} Help =====${NC}"
    echo -e "Usage: ${INSTALL_NAME} [COMMAND]"
    echo -e
    echo "License:"
    echo "- Apache 2.0"
    echo -e
    echo "Repository:"
    echo "- https://github.com/mik-tf/ubungpu"
    echo -e
    echo "Commands:"
    echo -e "${GREEN}  build${NC}           - Run full GPU setup"
    echo -e "${GREEN}  status${NC}          - Show GPU status"
    echo -e "${GREEN}  install${NC}         - Install script system-wide"
    echo -e "${GREEN}  uninstall${NC}       - Remove script from system"
    echo -e "${GREEN}  logs${NC}            - Show full logs"
    echo -e "${GREEN}  recent-logs [n]${NC} - Show last n lines of logs (default: 50)"
    echo -e "${GREEN}  delete-logs${NC}     - Delete all logs"
    echo -e "${GREEN}  help${NC}            - Show this help message"
    echo -e "${GREEN}  version${NC}         - Show version information"
    echo
    echo "Examples:"
    echo "  ${INSTALL_NAME} build            # Run full GPU setup"
    echo "  ${INSTALL_NAME} status           # Show GPU status"
    echo "  ${INSTALL_NAME} logs             # Show all logs"
    echo "  ${INSTALL_NAME} recent-logs 100  # Show last 100 log lines"
    echo "  ${INSTALL_NAME} delete-logs      # Delete all logs"
    echo
    echo "Requirements:"
    echo "- Ubuntu system (20.04 or newer recommended)"
    echo "- NVIDIA or AMD GPU"
    echo "- Must be run as root"
    echo -e
}

main() {
    clear
    echo -e "${BLUE}===== Unified GPU Setup Script v${VERSION} =====${NC}"
    
    install_prerequisites_and_dependencies
    setup_logging

    # Detect GPU type
    GPU_TYPE=$(detect_gpu_type)
    case $GPU_TYPE in
        "nvidia")
            echo -e "${GREEN}NVIDIA GPU detected${NC}"
            ;;
        "amd")
            echo -e "${GREEN}AMD GPU detected${NC}"
            ;;
        *)
            error "No supported GPU detected (NVIDIA or AMD required)"
            ;;
    esac
    
    setup_gpu
    show_gpu_info
    
    echo -e "\n${GREEN}Setup complete!${NC}"
    
    # Show restart message if needed
    case $GPU_TYPE in
        "nvidia")
            if ! nvidia-smi &>/dev/null; then
                echo -e "${YELLOW}Please restart your system to complete the NVIDIA driver installation.${NC}"
            fi
            ;;
        "amd")
            if ! lsmod | grep -q amdgpu; then
                echo -e "${YELLOW}Please restart your system to complete the AMD driver installation.${NC}"
            fi
            ;;
    esac
}

handle_command() {
    case "$1" in
        "status")
            show_status
            ;;
        "install")
            install
            ;;
        "uninstall")
            uninstall
            ;;
        "logs")
            show_logs
            ;;
        "recent-logs")
            show_recent_logs "${2:-50}"
            ;;
        "delete-logs")
            delete_logs
            ;;
        "help"|"")
            show_help
            ;;
        "version")
            show_version
            ;;
        "build")
            main
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}"
            show_help
            exit 1
            ;;
    esac
}

# Script execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    trap 'echo -e "\n${RED}Script interrupted${NC}"; exit 1' SIGINT SIGTERM
    handle_command "$1" "$2"
fi