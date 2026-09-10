#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

KERNEL="$ROOT/build/Image"
ROOTFS="$ROOT/build/rootfs.cpio.gz"

if [ ! -f "$KERNEL" ]; then
    echo "ERROR: Kernel not built."
    echo "Run: make"
    exit 1
fi

if [ ! -f "$ROOTFS" ]; then
    echo "ERROR: RootFS not built."
    echo "Run: make"
    exit 1
fi

echo "================================"
echo "          Starting MyOS"
echo "================================"

exec qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a72 \
    -m 1G \
    -smp 2 \
    -device virtio-gpu \
    -kernel "$KERNEL" \
    -initrd "$ROOTFS" \
    -append "console=ttyAMA0 earlycon=pl011,0x09000000" \
    -display vnc=:0 \
    -serial mon:stdio
