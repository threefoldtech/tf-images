#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Function to check Docker service status and attempt recovery
check_docker_service() {
    log "Checking Docker service status..."
    
    if ! systemctl is-active docker >/dev/null 2>&1; then
        warn "Docker service not active, attempting to start..."
        systemctl daemon-reload
        systemctl start docker.socket docker.service
        sleep 5
        
        if ! systemctl is-active docker >/dev/null 2>&1; then
            error "Failed to start Docker service"
        fi
    fi
    
    log "Docker service is running"
}

# Function to wait for Docker daemon
wait_for_docker() {
    local MAX_ATTEMPTS=30
    local attempt=1
    
    log "Waiting for Docker daemon to be ready..."
    
    while ! docker info >/dev/null 2>&1; do
        if [ $attempt -gt $MAX_ATTEMPTS ]; then
            error "Docker failed to start after $MAX_ATTEMPTS attempts"
        fi
        echo "Waiting for Docker... (attempt $attempt/$MAX_ATTEMPTS)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    log "Docker daemon is ready"
}

# Function to check GPU support
check_gpu_support() {
    if command -v nvidia-smi &> /dev/null && nvidia-smi &> /dev/null; then
        echo "nvidia"
    elif command -v rocm-smi &> /dev/null && rocm-smi &> /dev/null; then
        echo "amd"
    else
        echo "none"
    fi
}

# Function to pull Docker images
pull_images() {
    log "Pulling required Docker images..."
    
    if ! docker pull ghcr.io/open-webui/open-webui:ollama; then
        error "Failed to pull open-webui image"
    fi
    
    if ! docker pull containrrr/watchtower; then
        error "Failed to pull watchtower image"
    fi
    
    log "Successfully pulled all required images"
}

# Function to start containers
start-containers() {
    local GPU_TYPE=$(check_gpu_support)
    local GPU_ARGS=""
    
    if [ "$GPU_TYPE" = "nvidia" ]; then
        log "Detected NVIDIA GPU, enabling GPU acceleration"
        GPU_ARGS="--gpus all"
        
        # Verify NVIDIA runtime
        if ! docker info | grep -i "nvidia" >/dev/null; then
            warn "NVIDIA runtime not detected in Docker configuration"
            warn "Containers may not have GPU access"
        fi
    elif [ "$GPU_TYPE" = "amd" ]; then
        log "Detected AMD GPU, enabling GPU acceleration"
        GPU_ARGS="--device=/dev/kfd --device=/dev/dri"
    else
        warn "No supported GPU detected, running in CPU-only mode"
    fi
    
    # Stop existing containers if they exist
    log "Checking for existing containers..."
    if docker ps -a | grep -q open-webui; then
        log "Stopping existing open-webui container..."
        docker stop open-webui >/dev/null 2>&1
        docker rm open-webui >/dev/null 2>&1
    fi
    
    if docker ps -a | grep -q watchtower; then
        log "Stopping existing watchtower container..."
        docker stop watchtower >/dev/null 2>&1
        docker rm watchtower >/dev/null 2>&1
    fi
    
    # Start open-webui container
    log "Starting open-webui container..."
    if ! docker run -d \
        -p 8080:8080 \
        $GPU_ARGS \
        -v ollama:/root/.ollama \
        -v open-webui:/app/backend/data \
        --name open-webui \
        --restart always \
        ghcr.io/open-webui/open-webui:ollama; then
        error "Failed to start open-webui container"
    fi
    
    # Start watchtower container
    log "Starting watchtower container..."
    if ! docker run -d \
        --name watchtower \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        containrrr/watchtower -i 300 open-webui; then
        error "Failed to start watchtower container"
    fi
    
    log "All containers started successfully"
}

# Function to verify container status
verify_containers() {
    log "Verifying container status..."
    
    # Check open-webui container
    if ! docker ps | grep -q open-webui; then
        error "open-webui container is not running"
    fi
    
    # Check watchtower container
    if ! docker ps | grep -q watchtower; then
        error "watchtower container is not running"
    fi
    
    log "All containers are running properly"
}

# Main execution
main() {
    log "Starting container setup..."
    
    # Check and fix Docker service if needed
    check_docker_service
    
    # Wait for Docker to be ready
    wait_for_docker
    
    # Pull required images
    pull_images
    
    # Start containers
    start-containers
    
    # Verify container status
    verify_containers
    
    log "Container setup completed successfully"
    echo -e "${BLUE}Open WebUI will be available at: http://localhost:8080${NC}"
}

# Execute main function with error handling
if ! main; then
    error "Container setup failed"
fi