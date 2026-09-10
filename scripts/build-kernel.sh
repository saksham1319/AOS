#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

echo "================================"
echo "       Building MyOS Kernel"
echo "================================"

cd "$ROOT/kernel-src"

echo "==> Applying MyOS kernel config"
cp "$ROOT/kernel-config/myos.config" .config

echo "==> Resolving kernel configuration"
make olddefconfig

echo "==> Building kernel"
make -j"$(nproc)"

cp arch/arm64/boot/Image "$ROOT/build/Image"

echo
echo "================================"
echo "       Kernel build complete"
echo "================================"
ls -lh "$ROOT/build/Image"
