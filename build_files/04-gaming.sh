#!/bin/bash
set -euo pipefail
echo "==> Phase 4: Gaming"

pacman -S --noconfirm --needed \
    steam \
    lib32-mesa \
    lib32-libpulse \
    lib32-alsa-plugins

pacman -S --noconfirm --needed \
    gamescope \
    mangohud \
    lib32-mangohud \
    gamemode \
    lib32-gamemode

pacman -S --noconfirm --needed \
    lutris

pacman -S --noconfirm --needed \
    wine-staging \
    wine-mono \
    wine-gecko \
    winetricks \
    lib32-gnutls \
    lib32-sdl2 \
    lib32-libxcomposite \
    lib32-libxinerama \
    lib32-mpg123 \
    lib32-openal \
    lib32-v4l-utils \
    lib32-libpng \
    lib32-giflib \
    lib32-gst-plugins-base

pacman -S --noconfirm --needed \
    game-devices-udev

sudo -u builder yay -S --noconfirm --needed \
    protonup-qt-bin \
    || true

echo "==> Phase 4 complete"
