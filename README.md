# Eccys Arch desktop — serpantinum

Restore the desktop captured on 7 October 2026: Arch, Hyprland, the customized Serpantinum 2.2.4 shell, Zen, Nautilus, Fish/Kitty/Neovim, Discord Canary with the Ee!? encoder/decoder, OBS/EasyEffects, SnapX capture workflow, Lian Li configuration, services and automatic Btrfs snapshots.

Start from an installed, bootable Arch system with a regular sudo user and a working network. Root and `/home` must be Btrfs for the snapshots stage. Read [storage and hardware](docs/SYSTEM.md) before applying to another machine.

```sh
git clone --branch serpantinum https://github.com/eccys/dotfiles.git
cd dotfiles
./install.sh                   # inspect the plan
./install.sh --apply           # packages, configs, system, snapshots, browser, wallpapers, plugins
./install.sh --verify          # check the actual running host
```

The installer stops on errors, backs up changed managed files under `~/.local/state/eccys-restore/`, installs official packages through pacman, builds checked-in AUR recipes through makepkg, and builds a local `eccys-serpantinum` Arch package from a checksummed upstream archive plus the local patches. It enables services; log out and back in after a complete restore to start the new desktop. Discord and Zen need restarting after their settings are deployed.

Run an individual stage with `--only configs` or a comma-separated list. Test the config deployment without changing your login home with `--apply --only configs --target-home /tmp/eccys-test-home`. Run `python scripts/validate_repo.py` before modifying or publishing the repository.

This is a declarative package/configuration restore on rolling Arch. Package versions are recorded in `packages/installed-versions.txt`; official repositories supply their current compatible versions. It does not provide NixOS-style immutable generations or exact historical binary versions. Local source and patched shell assets are retained. Snapper provides recovery snapshots separately.

Public configuration alone cannot reproduce signed-in accounts, browser history/passwords, private keys, Steam game files or a Windows VM disk. [Private data](docs/PRIVATE-DATA.md) explains the required companion backup. Read [capture controls](docs/SCREENSHOTS.md) for the ShareX-style overlay and the remaining native SnapX limitations. [Validation](docs/VALIDATION.md) records what was actually tested.
