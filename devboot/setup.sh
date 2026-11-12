#!/bin/sh
# Install host build tools and fetch the kernel and BusyBox sources.
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
LINUX_VERSION="7.2.4"
BUSYBOX_VERSION="1.37.0"

sudo apt-get update
sudo apt-get install -y \
    build-essential bc bison flex libssl-dev libelf-dev cpio gzip git wget \
    qemu-system-arm qemu-efi-aarch64 podman

mkdir -p "$ROOT/build" "$ROOT/downloads"
cd "$ROOT/downloads"

if [ ! -d "$ROOT/kernel/src" ]; then
    wget "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-${LINUX_VERSION}.tar.xz"
    tar -xf "linux-${LINUX_VERSION}.tar.xz"
    mv "linux-${LINUX_VERSION}" "$ROOT/kernel/src"
fi

if [ ! -d "$ROOT/devboot/busybox" ]; then
    wget "https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2"
    tar -xf "busybox-${BUSYBOX_VERSION}.tar.bz2"
    mv "busybox-${BUSYBOX_VERSION}" "$ROOT/devboot/busybox"
fi
