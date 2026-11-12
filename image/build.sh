#!/bin/sh
# Build the AOS OS image with Podman.
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
TAG="${AOS_IMAGE:-localhost/aos:dev}"

exec podman build \
    --build-arg FEDORA_VERSION="${FEDORA_VERSION:-44}" \
    -t "$TAG" "$ROOT/image"
