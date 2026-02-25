# Hyprland Gaming Rig

A pure Arch Linux OCI image with everything baked in — no Fedora, no Bazzite, just `pacman`.

- **NVIDIA** open drivers + Vulkan
- **Hyprland** as the sole compositor
- **Caelestia / Quickshell** rice with matching Qt 6.x (no version mismatch)
- **Gaming** — Steam, Gamescope, MangoHud, Lutris, Wine, gamemode
- **Performance** — zram, gaming sysctl tweaks, I/O scheduler rules

Built weekly via GitHub Actions and pushed to GHCR.

## Architecture

```
┌──────────────────────────────────────────────┐
│  Arch Linux (archlinux:latest)               │
│  ├── NVIDIA open + Vulkan + 32-bit compat    │
│  ├── Hyprland + SDDM (Wayland session)       │
│  ├── Caelestia / Quickshell (Qt 6.x native)  │
│  ├── Steam + Gamescope + MangoHud + Lutris    │
│  ├── Wine + Proton + controller support       │
│  ├── PipeWire audio stack                     │
│  ├── Performance tweaks (zram, sysctl, udev)  │
│  └── CLI tools + fonts + theming              │
└──────────────────────────────────────────────┘
```

## Usage

### As a distrobox container (recommended for now)

```bash
distrobox create \
  --nvidia \
  --image ghcr.io/vumast3r/hyprland-gaming-rig:latest \
  --name gaming-rig \
  -Y

distrobox enter gaming-rig
```

Export apps to your host:

```bash
distrobox-export --app steam
distrobox-export --app lutris
distrobox-export --app discord
distrobox-export --app firefox
```

### Future: Bootable (Arkdep / Immuarch)

This image is structured to be adaptable to Arch immutable solutions like
[Arkdep](https://github.com/arkanelinux/arkdep) or
[Immuarch](https://bbs.archlinux.org/viewtopic.php?id=311910) when you're
ready to make it a bootable OS.

## Build phases

The image is assembled in seven sequential `RUN` steps:

| Script | Phase | What it does |
|--------|-------|--------------|
| `01-base.sh` | Base | Enables multilib, installs `base-devel`, sets up the `builder` AUR user, installs `yay` |
| `02-nvidia.sh` | NVIDIA | Installs open drivers, `nvidia-utils`, Vulkan loader, VA-API, OpenCL, container toolkit — including all `lib32-*` multilib variants |
| `03-hyprland.sh` | Hyprland | Installs Hyprland, portal, PipeWire/WirePlumber, dunst, rofi, grim/slurp, SDDM |
| `04-gaming.sh` | Gaming | Steam, Gamescope, MangoHud, Lutris, Wine (staging + deps), gamemode; AUR: `protonup-qt-bin`, `game-devices-udev` |
| `05-caelestia.sh` | Caelestia | Qt 6.x stack, `quickshell-git` (AUR), clones Caelestia shell + dotfiles into `/etc/skel` |
| `06-desktop.sh` | Desktop | kitty, fish, Thunar, mpv, Firefox, Discord, Nerd Fonts, CLI tools; AUR: `swww` |
| `07-finalize.sh` | Finalize | Installs `zram-generator`, `podman`, `flatpak`; clears pacman + yay caches |

## Building locally

```bash
podman build -t hyprland-gaming-rig -f Containerfile .
```

## Setup (GitHub CI/CD)

1. Fork/clone this repo
2. Generate cosign keys:
   ```bash
   cosign generate-key-pair
   ```
3. Add `SIGNING_SECRET` to GitHub Actions secrets (contents of `cosign.key`)
4. Commit `cosign.pub` to repo root
5. Enable GitHub Actions workflows
6. Push — image builds automatically and publishes to `ghcr.io/vumast3r/hyprland-gaming-rig:latest`

## Customization

| What | Where |
|------|-------|
| Packages | `build_files/01-base.sh` through `07-finalize.sh` |
| Hyprland config | `system_files/etc/skel/.config/hypr/hyprland.conf` |
| Gaming sysctl | `system_files/etc/sysctl.d/99-gaming.conf` |
| I/O scheduler | `system_files/etc/udev/rules.d/60-io-scheduler.rules` |
| zram swap | `system_files/etc/zram-generator/zram-generator.conf` |

## Contributing

### Adding packages

**Official repo packages** — add to the relevant `pacman -S --noconfirm --needed` block in the appropriate phase script.

**AUR packages** — always use the `yay` call at the end of the phase script:

```bash
sudo -u builder yay -S --noconfirm --needed \
    your-aur-package \
    || true
```

The `|| true` keeps AUR failures non-fatal so a single unavailable AUR package can't break the entire build.

> **Never install AUR packages with `pacman`** — they won't be found and the build will fail.

### `lib32-*` / multilib packages

All 32-bit packages live in the `[multilib]` repo. `01-base.sh` enables multilib and syncs the database; `02-nvidia.sh` re-syncs at the start of the phase as a safety net. If you add a new `lib32-*` package, place it in phase 2 or later — never in phase 1 before the initial sync completes.

### system_files

Drop any file you want present in the image under `system_files/` mirroring its final path. The `Containerfile` does `COPY system_files/ /` so `system_files/etc/foo` lands at `/etc/foo`.

## License

Apache-2.0
