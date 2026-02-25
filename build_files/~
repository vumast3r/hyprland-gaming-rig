#!/bin/bash
set -euo pipefail
echo "==> Phase 7: Performance + cleanup"

# zram for compressed swap
pacman -S --noconfirm --needed \
    zram-generator

# Distrobox compat (for nested use or host integration)
pacman -S --noconfirm --needed \
    podman \
    flatpak

# Cleanup
pacman -Scc --noconfirm
rm -rf /var/cache/pacman/pkg/*
rm -rf /home/builder/.cache/yay/*
rm -rf /tmp/*

echo ""
echo "============================================="
echo "  Hyprland Gaming Rig — Build complete!"
echo "============================================="
echo ""
echo "Everything included:"
echo "  - NVIDIA open drivers + Vulkan"
echo "  - Hyprland + Caelestia/Quickshell rice"
echo "  - Steam + Gamescope + MangoHud + Lutris"
echo "  - Wine + Proton + controller support"
echo "  - PipeWire audio"
echo "  - Performance tweaks (zram, sysctl)"
echo ""
echo "Distrobox usage:"
echo "  distrobox create --nvidia --image ghcr.io/vumast3r/hyprland-gaming-rig -n gaming-rig -Y"
echo "  distrobox enter gaming-rig"
echo ""
echo "Export apps:"
echo "  distrobox-export --app steam"
echo "  distrobox-export --app lutris"
echo "  distrobox-export --app discord"
echo ""
echo "============================================="

echo "==> Phase 7 complete"
