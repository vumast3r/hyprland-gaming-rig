#!/bin/bash
set -euo pipefail
echo "==> Phase 3: Hyprland + Wayland"

pacman -S --noconfirm --needed \
    hyprland \
    hyprpaper \
    hyprlock \
    hypridle \
    hyprpicker \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

pacman -S --noconfirm --needed \
    wayland \
    wayland-protocols \
    xorg-xwayland \
    wl-clipboard \
    wlr-randr \
    xdg-utils \
    xdg-desktop-portal

pacman -S --noconfirm --needed \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
    wireplumber \
    pavucontrol

pacman -S --noconfirm --needed \
    dunst \
    libnotify

pacman -S --noconfirm --needed \
    rofi-wayland

pacman -S --noconfirm --needed \
    grim \
    slurp \
    wf-recorder

pacman -S --noconfirm --needed \
    brightnessctl \
    playerctl

pacman -S --noconfirm --needed \
    sddm

echo "==> Phase 3 complete"
