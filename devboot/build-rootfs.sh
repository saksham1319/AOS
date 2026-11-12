#!/bin/sh
# Pack devboot/rootfs into build/rootfs.cpio.gz.
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

mkdir -p "$ROOT/build"
cd "$ROOT/devboot/rootfs"
find . -print0 | cpio --null -o --format=newc | gzip -9 > "$ROOT/build/rootfs.cpio.gz"
ls -lh "$ROOT/build/rootfs.cpio.gz"
