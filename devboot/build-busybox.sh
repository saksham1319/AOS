#!/bin/sh
# Build BusyBox and install it into devboot/rootfs.
set -eu
HERE="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cd "$HERE/busybox"
cp "$HERE/busybox.config" .config
make oldconfig
make -j"$(nproc)"
make CONFIG_PREFIX="$HERE/rootfs" install
ls -lh "$HERE/rootfs/bin/busybox"
