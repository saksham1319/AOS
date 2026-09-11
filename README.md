# AOS

**AOS** is a from-scratch operating system project focused on building a complete, independent computing environment from the ground up.

The project starts from a minimal Linux-based bootstrap and progressively replaces the underlying components with AOS-native implementations.

> **Status:** Early development / experimental

---

## Vision

The long-term goal of AOS is to build an operating system where the major layers of the system are developed and controlled within the AOS project itself.

The development roadmap broadly moves through:

```text
Applications
     │
     ▼
     Xefy UI Framework
     │
     ▼
   Runtime / Libraries
     │
     ▼
   Core Utilities
     │
     ▼
   Shell / Init
     │
     ▼
   AOS Kernel
     │
     ▼
   Hardware
```

The initial system uses existing open-source components as a bootstrap environment. These components are intended to be replaced progressively as AOS develops.

---

## Current Architecture

The current bootstrap system is based on:

```text
             AOS Userspace
                  │
          ┌───────┴───────┐
          │    BusyBox    │
          │   + /init     │
          └───────┬───────┘
                  │
                  ▼
            Linux Kernel
                  │
                  ▼
              virtio-gpu
                  │
                  ▼
                QEMU
```

The system currently boots an ARM64 Linux kernel with a custom initramfs.

---

## Current Features

- ARM64 kernel
- Custom Linux kernel configuration
- Custom initramfs
- BusyBox userspace
- Custom `/init`
- Static BusyBox build
- QEMU ARM64 boot support
- virtio-gpu support
- DRM framebuffer
- `/dev/fb0` framebuffer access
- Userspace framebuffer rendering
- Automated build scripts
- Make-based build system

A basic framebuffer test application can directly render pixels to the virtual display.

---

## Graphics Direction

AOS is intended to eventually provide a native graphical environment.

The planned graphics stack is:

```text
             Xefy
               │
               ▼
             Skia
               │
               ▼
            Vulkan
               │
               ▼
       AOS Graphics Layer
               │
               ▼
        DRM / GPU Backend
               │
               ▼
          Hardware
```

During early development, Linux DRM and virtio-gpu are used as the bootstrap graphics layer.

The eventual goal is to replace these dependencies with AOS-native components.

---

## Xefy

**Xefy** is the UI framework being developed alongside AOS.

It is designed around:

- Prismio
- Skia
- Native ARM64 executables
- AOS graphics backends

The same UI framework is intended to eventually power both system applications and third-party applications.

For example:

```text
AOS Desktop
     │
     ├── Settings
     ├── File Manager
     ├── Terminal
     └── Applications
             │
             ▼
           Xefy
```

---

## Prismio

AOS development also includes **Prismio**, a custom programming language/compiler toolchain.

Prismio is intended to provide a native development environment for AOS components and applications.

The long-term direction is to reduce dependence on external compiler and runtime infrastructure.

---

## Building

### Requirements

Currently, AOS is developed and tested on an ARM64 Linux environment.

Required tools include:

- GCC / build-essential
- AArch64 cross compiler
- QEMU
- CPIO
- Gzip
- Git
- Linux kernel build dependencies

### Setup

```bash
make setup
```

### Build

Build the kernel, BusyBox userspace, and initramfs:

```bash
make
```

or:

```bash
make build
```

### Run

Boot AOS in QEMU:

```bash
make run
```

The current development configuration uses:

```text
Architecture: ARM64
Machine:      QEMU virt
CPU:          Cortex-A72
Memory:       1 GB
CPUs:         2
GPU:          virtio-gpu
Display:      VNC
```

---

## Project Structure

```text
AOS/
├── build/              # Generated build artifacts
├── kernel-config/      # AOS Linux kernel configuration
├── rootfs/             # Root filesystem files
├── scripts/             # Build and run scripts
├── fbtest.c             # Framebuffer test program
├── busybox.config       # BusyBox configuration
├── Makefile
├── .gitignore
└── README.md
```

The Linux kernel and BusyBox source trees are not stored in the repository. They are external build dependencies.

---

## Development Roadmap

### Phase 1 — Bootstrap

- [x] ARM64 Linux kernel
- [x] BusyBox userspace
- [x] Custom initramfs
- [x] Automated build system
- [x] QEMU boot
- [x] virtio-gpu
- [x] Framebuffer rendering

### Phase 2 — Graphics

- [ ] Skia integration
- [ ] AOS graphics abstraction
- [ ] Xefy backend
- [ ] Window management
- [ ] Desktop environment
- [ ] Native system applications

### Phase 3 — Userspace

- [ ] Custom core utilities
- [ ] Custom shell
- [ ] Custom init/system manager
- [ ] Native filesystem utilities
- [ ] Package manager
- [ ] Native runtime libraries

### Phase 4 — Toolchain

- [ ] Expand Prismio
- [ ] AOS standard library
- [ ] Native compiler toolchain
- [ ] Native linker/runtime
- [ ] Self-hosting development environment

### Phase 5 — Kernel

- [ ] AOS kernel
- [ ] ARM64 boot process
- [ ] Memory management
- [ ] Process management
- [ ] Scheduler
- [ ] Syscall interface
- [ ] Filesystem layer
- [ ] Device drivers
- [ ] Graphics subsystem

### Long Term

The ultimate goal is for AOS to become increasingly self-hosted, replacing the initial bootstrap components with native AOS implementations.

---

## Philosophy

AOS is being developed incrementally.

Rather than attempting to implement an entire operating system at once, the project uses existing open-source software as a temporary bootstrap layer and replaces individual components over time.

```text
Bootstrap
    │
    ▼
Working System
    │
    ▼
Replace Components
    │
    ▼
Native AOS Components
    │
    ▼
Self-Hosted AOS
```

The emphasis is on understanding and controlling every layer of the system—from the kernel and runtime to graphics, applications, and eventually the development toolchain itself.

---

## License

The AOS project code is intended to use an open-source license.

Linux kernel, BusyBox, Skia, and other third-party components remain under their respective licenses and are not relicensed by AOS.

---

## Status

AOS is an experimental operating system under active development.

Expect breaking changes, incomplete components, and experimental architecture decisions.
