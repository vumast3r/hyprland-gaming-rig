#!/bin/bash
set -euo pipefail
echo "==> Phase 6: Desktop"

pacman -S --noconfirm --needed \
    kitty \
    fish \
    starship

pacman -S --noconfirm --needed \
    thunar \
    tumbler \
    gvfs \
    gvfs-mtp

pacman -S --noconfirm --needed \
    imv \
    mpv \
    firefox \
    discord

pacman -S --noconfirm --needed \
    fastfetch \
    bat \
    eza \
    fd \
    ripgrep \
    fzf \
    btop \
    jq \
    lazygit \
    zoxide \
    man-db \
    man-pages

pacman -S --noconfirm --needed \
    nwg-look \
    kvantum \
    kvantum-qt5 \
    qt5-wayland \
    qt6-wayland \
    gtk3 \
    gtk4

pacman -S --noconfirm --needed \
    ttf-jetbrains-mono-nerd \
    ttf-firacode-nerd \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    otf-font-awesome

sudo -u builder yay -S --noconfirm --needed \
    swww \
    || true

echo "==> Phase 6 complete"
