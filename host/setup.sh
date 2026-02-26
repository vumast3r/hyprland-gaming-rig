#!/bin/bash
# =============================================================================
# Hyprland Gaming Rig — Minimal Host Setup
# =============================================================================
# Run this after a minimal Arch install that already has:
#   base, linux, linux-firmware, grub, networkmanager
#
# What this script does:
#   1. Installs greetd, podman, distrobox, NVIDIA kernel module
#   2. Creates user 'joe' with the right groups
#   3. Configures GRUB with NVIDIA DRM kernel parameters
#   4. Installs the Hyprland session launcher
#   5. Enables greetd and NetworkManager
#
# Usage (as root, from the repo root):
#   bash host/setup.sh
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERNAME="joe"

if [[ $EUID -ne 0 ]]; then
    echo "error: run this script as root" >&2
    exit 1
fi

echo "==> Installing host packages"
pacman -Syu --noconfirm
pacman -S --noconfirm --needed \
    greetd \
    podman \
    distrobox \
    nvidia-open \
    linux-headers \
    egl-wayland

echo "==> Creating user '${USERNAME}'"
if ! id "${USERNAME}" &>/dev/null; then
    useradd -m -G wheel,video,input,audio,storage "${USERNAME}"
    echo ""
    echo "  Set a password for ${USERNAME}:"
    passwd "${USERNAME}"
else
    # Ensure the user is in all required groups
    usermod -aG wheel,video,input,audio,storage "${USERNAME}"
    echo "  User '${USERNAME}' already exists — groups updated"
fi

echo "==> Enabling wheel group in sudoers"
if ! grep -q "^%wheel ALL=(ALL:ALL) ALL" /etc/sudoers; then
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
fi

echo "==> Adding NVIDIA kernel parameters to GRUB"
GRUB_CONF="/etc/default/grub"
NVIDIA_PARAMS="nvidia-drm.modeset=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1"

if ! grep -q "nvidia-drm.modeset=1" "${GRUB_CONF}"; then
    # Append to existing GRUB_CMDLINE_LINUX_DEFAULT
    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 ${NVIDIA_PARAMS}\"/" "${GRUB_CONF}"
    echo "  Added: ${NVIDIA_PARAMS}"
else
    echo "  NVIDIA params already present — skipping"
fi

echo "==> Regenerating GRUB config"
grub-mkconfig -o /boot/grub/grub.cfg

echo "==> Installing session launcher"
install -m 0755 "${SCRIPT_DIR}/launch-hyprland.sh" /usr/local/bin/launch-hyprland

echo "==> Installing greetd config"
install -d /etc/greetd
install -m 0644 "${SCRIPT_DIR}/greetd.toml" /etc/greetd/config.toml

echo "==> Enabling services"
systemctl enable greetd
systemctl enable NetworkManager

echo ""
echo "============================================="
echo "  Host setup complete!"
echo "============================================="
echo ""
echo "  On first boot, greetd will autologin as '${USERNAME}' and"
echo "  launch Hyprland from inside the gaming-rig container."
echo ""
echo "  The container image will be pulled on first login."
echo "  This may take a few minutes on first boot."
echo ""
echo "  Update workflow (keep NVIDIA in sync):"
echo "    sudo pacman -Syu                          # update host kernel + nvidia-open"
echo "    podman pull ghcr.io/vumast3r/hyprland-gaming-rig:latest"
echo "    distrobox rm gaming-rig                   # recreate from new image"
echo "    sudo reboot"
echo ""
echo "  Reboot now to start your session."
echo "============================================="
