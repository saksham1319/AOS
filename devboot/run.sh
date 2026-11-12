#!/bin/sh
# Boot build/Image with build/rootfs.cpio.gz in QEMU. Display is on VNC :0, console on stdio.
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
KERNEL="$ROOT/build/Image"
ROOTFS="$ROOT/build/rootfs.cpio.gz"

for f in "$KERNEL" "$ROOTFS"; do
    [ -f "$f" ] || { echo "missing $f; run: make devboot" >&2; exit 1; }
done

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
