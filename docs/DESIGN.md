# AOS design

Version 0.4, 2026-11-12. Windows application support is not a goal, the compositor is reused
rather than written, and games are deferred until the OS itself is solid.

## 1. What AOS is

| Promise | What it means |
|---|---|
| Polished like macOS | One shell, one design language, one settings app, one update path |
| A full Linux machine | Real kernel, containers, any distribution's packages, Docker-compatible tooling |

Not goals:

- Running Windows applications. AOS has no `.exe` handling.
- Running macOS applications, phones and tablets, servers.

Deferred: games. Nothing in the design blocks them (Wayland, Flatpak and a current kernel
and Mesa are what Steam on Linux needs), but no game-specific work is planned until the
phases in `PLAN.md` up to P4 are done.

## 2. Principle: write only what the user sees

A desktop OS is thousands of components. AOS reuses a maintained open-source project for
every layer that has one and spends its own effort on the layer users judge: the shell,
Settings, first-party apps, defaults and visual design. `STACK.md` lists every component
with its source.

## 3. Decisions

| # | Decision | Choice | Reason |
|---|---|---|---|
| 1 | Kernel | Mainline stable Linux with an AOS config | Newest hardware support |
| 2 | Userland base | Fedora bootc image | The whole OS is a container image built from one `Containerfile`; current Mesa and kernel-adjacent packages |
| 3 | System model | Read-only image, atomic updates, rollback | An update fully applies or does not apply; a bad one is undone by rebooting |
| 4 | Display server | Wayland, with **KWin** as the compositor | It already has HDR, variable refresh, fractional scaling, direct scanout and XWayland handling. Writing a compositor would take years and add nothing users can see |
| 5 | Shell and first-party apps | Xefy apps in Prismio, running as Wayland clients of KWin | This is the part that makes AOS look and behave like one product |
| 6 | App format | Flatpak, with Flathub enabled | Sandboxing, permissions, portals and a large catalogue exist already |
| 7 | Developer environments | Podman containers of any distribution, through Distrobox | `apt`, `dnf` and `pacman` all work and none can damage the OS |
| 8 | Architectures | aarch64 and x86_64 from the same `Containerfile` | aarch64 is what the development VM runs and is tested daily; x86_64 is what most PCs are |

Decision 4 changes the Xefy plan, which had the compositor as a Xefy app on a DRM/KMS
embedder. See `docs/AOS_PLAN.md` and decision record 0023 in the Xefy repository.

## 4. Architecture

```
┌────────────────────────────────────────────────────────────────┐
│ Apps: AOS first-party (Xefy) · Flatpak · Linux environments    │
├────────────────────────────────────────────────────────────────┤
│ AOS shell (Xefy): bar, dock, launcher, notifications,          │  written by AOS
│ control centre, Settings, first-run setup                      │
├────────────────────────────────────────────────────────────────┤
│ KWin (Wayland compositor) · XWayland                           │
│ xdg-desktop-portal · Flatpak · Podman · Distrobox              │
│ PipeWire · NetworkManager · BlueZ · UPower · fwupd · systemd   │  reused
│ Mesa · bootc · composefs · Btrfs                               │
├────────────────────────────────────────────────────────────────┤
│ Linux kernel, AOS config                                       │
└────────────────────────────────────────────────────────────────┘
```

## 5. Base system

- `/usr` is read-only and identical on every machine running the same version.
- Updates download in the background into a second deployment and take effect on reboot. A
  deployment that fails to boot is rolled back automatically.
- `/home` and `/var` are Btrfs with snapshots.
- Later: unified kernel image, Secure Boot with AOS keys, disk encryption unlocked by TPM.
- An NVIDIA image variant ships the proprietary driver pre-built and signed.

## 6. Shell

The shell is a set of separate Xefy processes, each a Wayland client:

| Surface | Wayland mechanism |
|---|---|
| Top bar, dock, notifications, launcher, control centre | layer-shell surfaces |
| Dock window list, window switcher | KWin's window management protocol |
| Settings, Files, first-run setup | ordinary windows |
| Lock screen, login screen | reused at first (KDE's screen locker and SDDM), replaced last |

Each process is a systemd user service, so one crashing does not take the session down.

System state reaches the shell over D-Bus: NetworkManager, BlueZ, UPower, logind, PipeWire
(through WirePlumber), the freedesktop notification and status-notifier interfaces, MPRIS.

Until Xefy can draw these, the image runs KDE Plasma's shell on the same compositor. Each
AOS surface replaces its Plasma counterpart when it is ready, so the OS is usable at every
step.

Foreign apps (GTK, Qt) are made to match through themes, the system font, an icon theme and
the portal's colour-scheme setting.

## 7. Apps and development

- **Store**: a Flatpak front end. KDE Discover at first; an AOS Store in Xefy later.
- **AOS apps**: built with Xefy and shipped as Flatpaks, so `.xapp` permissions map onto
  Flatpak permissions and portals instead of a new sandbox.
- **Linux environments**: `aos env create ubuntu` creates a Distrobox container that shares
  the home directory, GPU and display. Graphical apps installed inside it appear in the
  launcher. The default terminal opens in a default environment.
- **Containers and VMs**: Podman with a Docker-compatible socket; KVM and libvirt.
- **Developer mode**: unlocks the system image for people who need out-of-tree kernel
  modules, with a visible indicator.

## 8. Quality bar

These are scheduled work, listed in `PLAN.md`: first-run setup, backup from Btrfs snapshots,
consistent shortcuts, clipboard history, screenshots and recording, file previews, reliable
suspend and external displays, accessibility, input methods, and a certified hardware list
that every release is tested on.

## 9. Security

Read-only verified system image, signed updates, sandboxed Flatpak apps with portal
permission prompts, and (later) Secure Boot and TPM-backed disk encryption.

## 10. Build and test

- `image/Containerfile` is the OS. `make image` builds it with Podman; `make disk` produces a
  bootable disk with bootc-image-builder.
- The development VM is aarch64 and has no KVM, so the disk is booted as its own VM on the
  host (UTM), not nested inside the development VM.
- CI builds the image for both architectures and boots it headless as a smoke test.
- GPU features, suspend and external displays are tested on real hardware.

## 11. Risks

| Risk | Mitigation |
|---|---|
| Scope | Reuse everything below the shell; `STACK.md` is the list of what AOS refuses to write |
| Xefy is at scaffold stage and the shell depends on it | Phases P0 and P1 need no Xefy; Plasma's shell stays until each replacement is ready |
| KWin may restrict protocols a third-party shell needs | Spike P2.1 tests this before any shell work; fallback is a wlroots compositor (labwc or Wayfire) |
| NVIDIA and laptop quirks | Certified hardware list; pre-built signed drivers |
| Prismio limits (one thread, no stored closures) | Shell processes stay small and event-driven; requirements feed Prismio's plan |
