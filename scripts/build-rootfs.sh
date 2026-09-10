#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

echo "================================"
echo "       Building MyOS RootFS"
echo "================================"

mkdir -p "$ROOT/build"

cd "$ROOT/rootfs"

echo "==> Creating initramfs"

find . -print0 | cpio --null -ov --format=newc | gzip -9 > "$ROOT/build/rootfs.cpio.gz"

echo
echo "================================"
echo "       RootFS build complete"
echo "================================"

ls -lh "$ROOT/build/rootfs.cpio.gz"
