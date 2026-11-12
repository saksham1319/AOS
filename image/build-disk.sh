#!/bin/sh
# Install the AOS image onto a disk file with bootc and convert it to qcow2.
# Needs root Podman, because the installer partitions a loop device.
#
# The development host (Ubuntu) has no SELinux, and bootc cannot label a disk from such a
# host, so the disk is installed with SELinux disabled. Disks built on a Fedora host or in CI
# keep it enabled.
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
BASE="${AOS_IMAGE:-localhost/aos:dev}"
TAG="${BASE}-vm"
OUT="$ROOT/build/disk"
SIZE="${AOS_DISK_SIZE:-24G}"
mkdir -p "$OUT"

# Add the development login on top of the image.
podman build --build-arg BASE="$BASE" -t "$TAG" -f "$ROOT/image/Containerfile.dev" "$ROOT/image"

# The image was built rootless; copy it into root storage unless that copy is current.
want="$(podman image inspect -f "{{.Id}}" "$TAG")"
have="$(sudo podman image inspect -f "{{.Id}}" "$TAG" 2>/dev/null || true)"
if [ "$want" != "$have" ]; then
    podman save "$TAG" | sudo podman load
fi

SELINUX_ARG=""
if [ ! -d /sys/fs/selinux ] || [ ! -e /sys/fs/selinux/enforce ]; then
    SELINUX_ARG="--disable-selinux"
fi

rm -f "$OUT/disk.raw" "$OUT/disk.qcow2"
truncate -s "$SIZE" "$OUT/disk.raw"

sudo podman run --rm --privileged --pid=host \
    --security-opt label=type:unconfined_t \
    -v /dev:/dev \
    -v /var/lib/containers:/var/lib/containers \
    -v "$OUT":/output \
    "$TAG" \
    bootc install to-disk --generic-image --via-loopback --wipe \
        --filesystem btrfs --skip-fetch-check $SELINUX_ARG /output/disk.raw

qemu-img convert -O qcow2 "$OUT/disk.raw" "$OUT/disk.qcow2"
rm -f "$OUT/disk.raw"
ls -lh "$OUT/disk.qcow2"
