# AOS plan

Phases P0 and P1 need neither Xefy nor Prismio and can start now. P2 onward is gated on the
Xefy work listed in `docs/AOS_PLAN.md` of the Xefy repository.

Status: `done`, `next`, `blocked: <on what>`, or blank for not started.

## P0. A bootable AOS image

| # | Item | Done when | Status |
|---|---|---|---|
| P0.1 | Restructure the repository: `image/`, `kernel/`, `devboot/`, docs | `make help` lists the targets; `make devboot` still builds | done, not rebuilt |
| P0.2 | Host tools: Podman on the dev VM, enough disk | `podman info` works; 61 GB free | done |
| P0.3 | First image build | `make image` succeeds; `bootc container lint` passes | done: 5.0 GB image, aarch64, Fedora 44 base, built 2026-11-12 |
| P0.4 | Bootable disk | `make disk` writes `build/disk/disk.qcow2` that boots to the login screen as a UTM VM | done: boots to `graphical.target` and the SDDM login screen in QEMU on the Mac in about 15 s. Disk is installed with SELinux off because the Ubuntu host has none. Login screen and hostname still say Fedora (P1.3) |
| P0.5 | Session works | Log in to a Wayland session; install and run a Flatpak; `distrobox create` an Ubuntu container and run `apt` in it | next |
| P0.6 | Update and rollback | Publish a second image version, `bootc upgrade`, reboot into it, `bootc rollback` | |
| P0.7 | Kernel config toward desktop | DRM drivers, Btrfs, overlayfs, FUSE built in or as modules; still boots in `devboot` | |

## P1. Identity, tooling, x86_64

| # | Item | Done when |
|---|---|---|
| P1.1 | x86_64 image built in CI (GitHub Actions) alongside aarch64 | Both images published to a registry on every push |
| P1.2 | Boot smoke test in CI | The image boots headless in QEMU and reaches `graphical.target` |
| P1.3 | Branding and defaults: name, wallpaper, boot splash, login theme, fonts, KDE and GTK themes following Xefy's Porcelain tokens | A fresh boot shows no Fedora or KDE branding |
| P1.4 | `aos` tool: `aos env create/enter/list/remove`, `aos update`, `aos rollback`, `aos status` | Commands work on a booted image |
| P1.5 | NVIDIA image variant with the signed proprietary driver | Boots to a Wayland session on an NVIDIA machine |
| P1.6 | Installer ISO | A machine can be installed from USB |
| P1.7 | Choose the x86_64 test machine and start the certified hardware list | Written in `docs/HARDWARE.md` |

## P2. First AOS surfaces

Blocked on Xefy: framework v0 (Xefy build plan phases A to D) and Xefy AOS plan phases F and G.

| # | Item | Done when |
|---|---|---|
| P2.1 | **Spike:** a plain C Wayland client that puts a bar on a layer-shell surface and lists open windows under KWin | Works without being a KDE-trusted client, or the needed permission is documented. If it cannot work, switch the compositor to labwc or Wayfire before any shell code is written. This spike needs no Xefy and can run during P0 |
| P2.2 | Launcher and search as a Xefy app | Opens on a shortcut, launches apps from `.desktop` files |
| P2.3 | Settings: display, sound, network, Bluetooth, appearance, about | Daily use needs no KDE System Settings |

## P3. The AOS shell

| # | Item | Done when |
|---|---|---|
| P3.1 | Top bar: clock, status items, network, sound, battery | Plasma panel removed |
| P3.2 | Dock with running windows | |
| P3.3 | Notifications and notification centre | AOS owns `org.freedesktop.Notifications` |
| P3.4 | Control centre | |
| P3.5 | Window switcher, overview, animations tuned through KWin | |
| P3.6 | Remove the Plasma shell from the image | `plasmashell` is not installed |

## P4. Polish and public beta

First-run setup; backup and restore from Btrfs snapshots; AOS lock and login screens;
accessibility pass with Orca; input methods; clipboard history; screenshots and recording;
store front end; Secure Boot and disk encryption; certified hardware list tested.

## P5. Platform

Files, Terminal and a text editor in Xefy; `xefy bundle` producing Flatpaks; an AOS Flatpak
runtime carrying the shared Xefy engine; third-party app submissions; x86 translation on
aarch64 with FEX.

## Deferred

Games: Steam, a gamescope session, controller rules, performance overlay. Revisit after P4.

## Open questions

1. Which x86_64 machine is the hardware test target?
2. Fedora 44 or 45 as the first base?
3. The Xefy documents call the OS "XefyOS". Is AOS the final name, and should the Xefy
   documents be renamed?
4. Keep or drop the Prismio-in-kernel work? It is not needed by any phase above. Either way
   it should be committed to a branch, since it exists only as uncommitted changes.
