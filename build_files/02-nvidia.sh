#!/bin/bash
set -euo pipefail
echo "==> Phase 2: NVIDIA"

pacman -S --noconfirm --needed \
    nvidia-open \
    nvidia-utils \
    lib32-nvidia-utils \
    nvidia-settings \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    vulkan-tools \
    libva-nvidia-driver \
    opencl-nvidia \
    lib32-opencl-nvidia \
    nvidia-container-toolkit

echo "==> Phase 2 complete"
