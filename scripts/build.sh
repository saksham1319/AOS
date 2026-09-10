#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

echo "================================"
echo "          Building MyOS"
echo "================================"

echo
echo "==> Step 1/3: Kernel"
"$ROOT/scripts/build-kernel.sh"

echo
echo "==> Step 2/3: BusyBox"
"$ROOT/scripts/build-busybox.sh"

echo
echo "==> Step 3/3: RootFS"
"$ROOT/scripts/build-rootfs.sh"

echo
echo "================================"
echo "       MyOS build complete"
echo "================================"

echo
echo "Artifacts:"
ls -lh \
    "$ROOT/build/Image" \
    "$ROOT/build/rootfs.cpio.gz"
