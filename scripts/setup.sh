#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

echo "==> Installing dependencies"

sudo apt-get update

sudo apt-get install -y \
    build-essential \
    bc \
    bison \
    flex \
    libssl-dev \
    libelf-dev \
    cpio \
    gzip \
    git \
    wget \
    qemu-system-arm \
    gcc-aarch64-linux-gnu

echo "==> Preparing source directories"

mkdir -p "$ROOT/build"
mkdir -p "$ROOT/downloads"

LINUX_VERSION="7.2.4"
BUSYBOX_VERSION="1.37.0"

if [ ! -d "$ROOT/kernel-src" ]; then
    echo "==> Downloading Linux $LINUX_VERSION"

    cd "$ROOT/downloads"

    wget "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-${LINUX_VERSION}.tar.xz"

    tar -xf "linux-${LINUX_VERSION}.tar.xz"

    mv "linux-${LINUX_VERSION}" "$ROOT/kernel-src"
fi

if [ ! -d "$ROOT/busybox" ]; then
    echo "==> Downloading BusyBox $BUSYBOX_VERSION"

    cd "$ROOT/downloads"

    wget "https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2"

    tar -xf "busybox-${BUSYBOX_VERSION}.tar.bz2"

    mv "busybox-${BUSYBOX_VERSION}" "$ROOT/busybox"
fi

echo
echo "================================"
echo "        MyOS setup complete"
echo "================================"
