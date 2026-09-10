#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

echo "================================"
echo "       Building BusyBox"
echo "================================"

cd "$ROOT/busybox"

echo "==> Applying MyOS BusyBox config"
cp "$ROOT/busybox.config" .config

echo "==> Resolving BusyBox configuration"
make oldconfig

echo "==> Building BusyBox"
make -j"$(nproc)"

echo "==> Installing BusyBox into rootfs"

make CONFIG_PREFIX="$ROOT/rootfs" install

echo
echo "================================"
echo "       BusyBox build complete"
echo "================================"

ls -lh "$ROOT/rootfs/bin/busybox"
