#!/bin/bash
# Launches Hyprland from inside the gaming-rig distrobox container.
# Called by greetd on boot as user joe.
# On first run, creates the container from the OCI image.

set -euo pipefail

CONTAINER_NAME="gaming-rig"
IMAGE="ghcr.io/vumast3r/hyprland-gaming-rig:latest"

# Create the container if it doesn't exist yet
if ! distrobox list 2>/dev/null | grep -q "^${CONTAINER_NAME}"; then
    echo "First run: creating ${CONTAINER_NAME} container..."
    distrobox create \
        --name "${CONTAINER_NAME}" \
        --image "${IMAGE}" \
        --additional-flags " \
            --device /dev/dri \
            --volume /dev/input:/dev/input \
            --device /dev/nvidia0 \
            --device /dev/nvidiactl \
            --device /dev/nvidia-modeset \
            --device /dev/nvidia-uvm \
            --device /dev/nvidia-uvm-tools \
            --volume /run/udev:/run/udev:ro \
            --group-add keep-groups" \
        --pull \
        --yes
fi

# Hand off to Hyprland inside the container.
# hyprland.conf sets all NVIDIA env vars (GBM_BACKEND, LIBVA_DRIVER_NAME, etc.)
exec distrobox enter "${CONTAINER_NAME}" -- Hyprland
