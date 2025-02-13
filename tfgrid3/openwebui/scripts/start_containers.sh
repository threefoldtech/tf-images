#!/bin/bash

# Wait for Docker daemon
while ! docker info >/dev/null 2>&1; do
    echo "Waiting for Docker..."
    sleep 2
done

# Add GPU detection
check_gpu_support() {
    if command -v nvidia-smi &> /dev/null && nvidia-smi &> /dev/null; then
        echo "nvidia"
    elif command -v rocm-smi &> /dev/null && rocm-smi &> /dev/null; then
        echo "amd"
    else
        echo "none"
    fi
}

GPU_TYPE=$(check_gpu_support)
GPU_ARGS=""

if [ "$GPU_TYPE" != "none" ]; then
    log "Detected $GPU_TYPE GPU, enabling GPU acceleration"
    GPU_ARGS="--gpus=all"
else
    log "No supported GPU detected, running in CPU mode"
fi

# Update docker run command
docker run \
  -d \
  -p 8080:8080 \
  $GPU_ARGS \
  -v ollama:/root/.ollama \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:ollama