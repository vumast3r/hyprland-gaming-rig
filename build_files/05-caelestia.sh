#!/bin/bash
set -euo pipefail
echo "==> Phase 5: Caelestia"

pacman -S --noconfirm --needed \
    qt6-base \
    qt6-declarative \
    qt6-wayland \
    qt6-svg \
    qt6-5compat \
    qt6-shadertools

sudo -u builder yay -S --noconfirm --needed quickshell-git || true

pacman -S --noconfirm --needed \
    polkit-gnome \
    network-manager-applet \
    bluez \
    bluez-utils \
    blueman

mkdir -p /etc/skel/.config

git clone --depth 1 https://github.com/caelestia-dots/shell.git \
    /etc/skel/.config/caelestia-shell 2>/dev/null || \
    echo "WARN: Could not clone caelestia-shell"

git clone --depth 1 https://github.com/caelestia-dots/dotfiles.git \
    /tmp/caelestia-dots 2>/dev/null || \
    echo "WARN: Could not clone caelestia-dots"

if [ -d /tmp/caelestia-dots ]; then
    cp -r /tmp/caelestia-dots/.config/* /etc/skel/.config/ 2>/dev/null || true
    rm -rf /tmp/caelestia-dots
fi

echo "==> Phase 5 complete"
