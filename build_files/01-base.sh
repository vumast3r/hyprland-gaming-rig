#!/bin/bash
set -euo pipefail
echo "==> Phase 1: Base system"

sed -i 's/^#\[multilib\]/[multilib]/' /etc/pacman.conf
sed -i '/^\[multilib\]/{n;s/^#Include/Include/}' /etc/pacman.conf
grep -q '^\[multilib\]' /etc/pacman.conf || \
    printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf
sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf

pacman -Sy --noconfirm
pacman -Syu --noconfirm

pacman -S --noconfirm --needed \
    base-devel git wget curl sudo which \
    nano vim unzip p7zip openssh \
    pkgconf cmake meson ninja

useradd -m -G wheel builder 2>/dev/null || true
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

sudo -u builder bash -c '
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg -si --noconfirm
'
rm -rf /tmp/yay-bin

echo "==> Phase 1 complete"
