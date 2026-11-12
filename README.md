# AOS

AOS is a desktop operating system on the Linux kernel. The goal is one OS that is polished
like macOS and a full Linux machine for development. Games are a later goal; the OS itself
comes first.

It is assembled from maintained open-source components wherever one exists. AOS writes only
what the user sees and touches: the shell, the settings, the first-party apps and the
defaults. Those are written in [Prismio](https://prismio.org) with the Xefy UI framework.

## Status

Early. What exists today:

- `devboot/`: a Linux kernel plus BusyBox initramfs that boots in QEMU. It is the fast test
  harness for kernel work, not the OS userland.
- `kernel/`: the AOS kernel configuration and build script.
- `image/`: the definition of the real OS image (Fedora bootc base, KWin, Flatpak, Podman).
  It builds on aarch64 and boots to the login screen in a VM. The desktop session
  has not been tested yet.
- `docs/`: the design and the plan.

There is no AOS shell yet. Until Xefy can draw one, the image boots into a stock KDE Plasma
session.

## Layout

| Path | What it is |
|---|---|
| `image/` | The OS image: `Containerfile`, files copied into the image, build and run scripts |
| `kernel/` | Kernel config (`config/aos.config`) and build script. Source is fetched to `kernel/src/` (gitignored) |
| `devboot/` | Kernel + BusyBox initramfs boot harness for QEMU |
| `shell/` | The AOS shell and first-party apps (Xefy). Empty until Xefy has a Wayland embedder |
| `tools/` | The `aos` command line tool. Empty for now |
| `docs/` | [DESIGN.md](docs/DESIGN.md), [STACK.md](docs/STACK.md), [PLAN.md](docs/PLAN.md) |

## Building

Development happens on a Linux host. The current one is an aarch64 Ubuntu 26.04 VM.

Install the host tools once (kernel build tools, QEMU, Podman):

```bash
make setup
```

Build and boot the kernel test harness:

```bash
make devboot
```

```bash
make devboot-run
```

Build the OS image, then turn it into a bootable disk:

```bash
make image
```

```bash
make disk
```

`make disk` writes `build/disk/disk.qcow2` with a development login (user `aos`, set in
`image/Containerfile.dev`). The development VM has no KVM, so boot that
disk as its own virtual machine on the host (UTM on macOS) rather than inside the VM.

## Documentation

- [docs/DESIGN.md](docs/DESIGN.md): what AOS is, the architecture and the decisions
- [docs/STACK.md](docs/STACK.md): every component, and whether AOS reuses it or writes it
- [docs/PLAN.md](docs/PLAN.md): phases, work items and what blocks what
