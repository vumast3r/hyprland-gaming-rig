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

## License

Apache-2.0
