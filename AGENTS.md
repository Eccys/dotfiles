# Restoring this desktop

Read README.md and docs/SYSTEM.md, PRIVATE-DATA.md, SCREENSHOTS.md, VALIDATION.md first. Use install.sh; do not replace it with an upstream theme install script, which loses the local changes. Inspect the plan before --apply. Run as the target desktop user, using sudo only for system operations.

Preserve existing home contents. Check manifest checksums with scripts/validate_repo.py. Do not delete/reformat partitions or copy host UUIDs, fstab, crypttab, machine identity, sudo policy or credentials across computers. Get the target's actual disk layout and monitor connectors before adapting those settings. Existing Btrfs subvolumes must remain intact.

The public repo is one half of the restore. Report missing private data explicitly. Browser preferences/extensions are restorable; signed-in browser data, keys, account state, screenshot history and Windows/Steam disks come from a separately encrypted backup. Never add that private material to Git.

Run install.sh --verify after installation. Check Hyprland configerrors, live screenshot/save/clipboard behavior, package presence, timers and root/home snapshot creation. Enabled services alone do not prove they work. Record unresolved hardware/app issues instead of marking the restore complete. Rear Lian Li group discovery and the weather API were unresolved at capture time; faithfully restoring their config does not fix those issues.

Boot setup and Windows-backed Dubbing AI are target-specific. Do not start the Windows VM against a writable backing volume or an outdated disk overlay. Keep users' current sessions/calls running until they choose to restart applications.
