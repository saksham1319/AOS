#!/bin/sh
# Build the AOS kernel from kernel/src with kernel/config/aos.config.
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

case "$(uname -m)" in
    aarch64) IMAGE=arch/arm64/boot/Image ;;
    x86_64)  IMAGE=arch/x86/boot/bzImage ;;
    *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

mkdir -p "$ROOT/build"
cd "$ROOT/kernel/src"
cp "$ROOT/kernel/config/aos.config" .config
make olddefconfig
make -j"$(nproc)"
cp "$IMAGE" "$ROOT/build/Image"
ls -lh "$ROOT/build/Image"
