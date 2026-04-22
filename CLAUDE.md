# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal NixOS flake configuration using [flake-parts](https://flake.parts/) for two hosts:
- **zoltraak** — active media/storage server
- **judradjim** — desktop (currently disabled in flake outputs)

## Commands

```bash
nix fmt                            # Format all files (deadnix, statix, alejandra, prettier)
nix flake show                     # List all flake outputs
nix flake check                    # Check flake validity

# In devshell (nix develop or direnv):
switch                             # nixos-rebuild switch --flake . --sudo
boot                               # nixos-rebuild boot --flake . --sudo
deploy .#zoltraak                  # Deploy to zoltraak via deploy-rs (auto-rollback enabled)

# Secrets
sops hosts/zoltraak/secrets.yaml           # Edit encrypted secrets
sops updatekeys hosts/zoltraak/secrets.yaml  # Rekey after adding new age keys
```

## Architecture

### Configuration Layers (applied in this order)

1. **`/hosts/common/global/`** — Applied to all hosts: nix daemon, SSH, SOPS, impermanence, Podman
2. **`/hosts/common/optional/`** — Opt-in features: GNOME, Hyprland, NVIDIA, PipeWire, fonts, Plymouth
3. **`/hosts/<hostname>/`** — Host-specific: hardware, disko, networking, services
4. **`/users/`** — User accounts + Home Manager configs per host

The `mkHost` function in `/hosts/default.nix` is the factory that assembles these layers into a NixOS configuration.

### Key Patterns

**Flake-parts**: `/parts/` contains the flake module outputs — devshell (`shell.nix`), formatter (`fmt.nix`), deploy config (`deploy.nix`), custom packages (`pkgs/`), and the nvf-based Neovim build (`nvim/`).

**Impermanence + btrfs**: zoltraak uses blank btrfs snapshots for ephemeral root. Persistent state lives under `/persist`. The nuke module (`/modules/system/nuke.nix`) handles root reset on boot.

**SOPS secrets**: Each host has a `secrets.yaml` encrypted with age keys derived from SSH host keys. The `.sops.yaml` at root defines which keys encrypt which files.

**Custom modules** in `/modules/`:
- `mover/` — Mergerfs cache-to-storage automation (systemd timer, Python)
- `forward/` — Port forwarding (NAT-PMP)
- `services/nfs-exports.nix` — NFS export configuration

**Custom packages** in `/parts/pkgs/packages/` are auto-discovered via `packagesFromDirectoryRecursive` and exposed as an overlay.

### Host: zoltraak

Services live in `/hosts/zoltraak/services/` — ~20 services including Jellyfin, Plex, arr suite, Immich, Navidrome, Frigate, Mealie, qBittorrent, SABnzbd, Samba, NFS, PostgreSQL, Beszel.

Storage layout (disko): btrfs on ZFS-style subvolumes — root, home, nix, persist, log, swap.

Deployment target: `tydooo@10.10.50.50` via deploy-rs with magic-rollback.

### User: tydooo

Home Manager configs split by host context:
- `users/tydooo/home/common.nix` — Stylix theming (Rose Pine dark), shared programs
- `users/tydooo/home/zoltraak.nix` / `judradjim.nix` — Host-specific home config
- `users/tydooo/home/programs/` — Terminal tools (Zsh, Starship, Zellij, Helix, Git, fzf, yazi, etc.)
- `users/tydooo/home/desktop/` — GUI apps (Hyprland, Rofi, Discord, Spicetify, Kitty)
