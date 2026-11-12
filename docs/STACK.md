# AOS stack: what exists, what is reused, what is written

## Exists today

| Thing | Where | State |
|---|---|---|
| Kernel 7.2.4 config and build | `kernel/` | Builds for aarch64; boots in QEMU |
| BusyBox initramfs boot harness with framebuffer test | `devboot/` | Boots in QEMU |
| OS image definition | `image/Containerfile` | Builds on aarch64; boots to the login screen in a VM |
| Prismio compiler 0.2.0 | separate repository | Self-hosted, LLVM backend, links with C |
| Prismio support in the kernel build, sample modules | `~/Projects/linux` on the dev VM, uncommitted | Two samples fail to link (`ktime_get_ns` undefined) |
| Xefy | separate repository | Scaffold and documents; no rendering yet |

## Reused (not written by AOS)

| Layer | Component | Notes |
|---|---|---|
| Kernel | Linux, mainline stable | AOS owns only the config |
| Base userland, packages | Fedora (bootc base image) | Confined to `image/Containerfile` |
| Image updates, rollback | bootc, composefs, ostree | |
| Init, services, login sessions | systemd, logind | |
| File system | Btrfs | Snapshots for backup |
| Boot | systemd-boot or GRUB from the base; Plymouth for the splash | |
| Compositor | KWin (Wayland) | Kept long term |
| Legacy X11 apps | XWayland | |
| Graphics drivers | Mesa; NVIDIA proprietary driver in a variant image | |
| Audio and video | PipeWire, WirePlumber | |
| Network, Bluetooth | NetworkManager, BlueZ | |
| Power | UPower, tuned-ppd | |
| Firmware updates | fwupd | |
| Printing | CUPS | |
| Input methods | IBus or Fcitx 5 | Decide in P4 |
| App format and sandbox | Flatpak, Flathub, bubblewrap | |
| Permissions and system dialogs | xdg-desktop-portal with the KDE backend | AOS backend later for its own dialogs |
| Containers | Podman, Distrobox | |
| Virtual machines | KVM, QEMU, libvirt | |
| Login screen | SDDM | Replaced in P4 |
| Lock screen | KDE screen locker | Replaced in P4 |
| Interim shell and apps | KDE Plasma shell, Dolphin, Konsole, Discover | Removed as AOS equivalents land |
| File search index | Baloo | |
| Screen reader | Orca | Needs Xefy to expose an accessibility tree |
| Installer and disk images | bootc-image-builder, Anaconda | |
| 2D rendering, text | Skia, HarfBuzz, ICU | Through Xefy |
| Accessibility bridge | AccessKit (C bindings) | Through Xefy |
| D-Bus client | sd-bus (libsystemd) | Bound from Prismio |

## Written by AOS

| Thing | Depends on | Phase |
|---|---|---|
| Image definition, defaults, branding (name, wallpaper, boot splash, themes for KDE and GTK apps) | nothing | P0, P1 |
| Kernel config for desktop hardware | nothing | P0 |
| `aos` command line tool: environments, update, rollback | nothing | P1 |
| CI: build, boot test, publish image | nothing | P1 |
| Launcher and search | Xefy Wayland embedder | P2 |
| Settings | Xefy, D-Bus binding | P2 |
| Top bar, dock, notifications, control centre | Xefy layer-shell, D-Bus binding | P3 |
| Window switcher and overview | KWin scripting or effects | P3 |
| First-run setup, backup, store front end | Xefy | P4 |
| Lock and login screens | Xefy session-lock support | P4 |
| Files, Terminal, text editor | Xefy text field, scrolling | P5 |
| SDK: `xefy bundle` to Flatpak, AOS Flatpak runtime | Xefy CLI | P5 |

## Explicitly not written

A kernel, a C library, a package manager, a compositor, a display protocol, a sandbox, an
audio server, a network stack, a Windows compatibility layer, an installer.
