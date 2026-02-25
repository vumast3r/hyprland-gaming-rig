# =============================================================================
# Hyprland Gaming Rig — Pure Arch Linux
# =============================================================================
# Everything in one image: NVIDIA, Hyprland, Caelestia, gaming stack.
# No Fedora, no rpm-ostree, just pacman.
#
# Build:  podman build -t hyprland-gaming-rig -f Containerfile .
# Use:    distrobox create --nvidia --image ghcr.io/vumast3r/hyprland-gaming-rig -n gaming-rig -Y
#         distrobox enter gaming-rig
# =============================================================================

FROM docker.io/archlinux/archlinux:latest

LABEL name="hyprland-gaming-rig"
LABEL description="Pure Arch Linux — Hyprland + Caelestia rice + NVIDIA gaming"

COPY system_files/ /
COPY build_files/ /tmp/build_files/
RUN chmod +x /tmp/build_files/*.sh

# Phase 1: Base system, multilib, AUR helper
RUN /tmp/build_files/01-base.sh

# Phase 2: NVIDIA drivers + Vulkan
RUN /tmp/build_files/02-nvidia.sh

# Phase 3: Hyprland + Wayland compositor stack
RUN /tmp/build_files/03-hyprland.sh

# Phase 4: Gaming — Steam, Gamescope, MangoHud, Lutris, Wine
RUN /tmp/build_files/04-gaming.sh

# Phase 5: Caelestia — Quickshell + rice dotfiles
RUN /tmp/build_files/05-caelestia.sh

# Phase 6: Desktop apps, fonts, theming, CLI tools
RUN /tmp/build_files/06-desktop.sh

# Phase 7: Performance tuning + cleanup
RUN /tmp/build_files/07-finalize.sh

RUN rm -rf /tmp/build_files
