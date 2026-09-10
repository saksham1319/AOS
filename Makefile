.PHONY: all setup build kernel busybox rootfs run clean

all: build

setup:
	./scripts/setup.sh

build:
	./scripts/build.sh

kernel:
	./scripts/build-kernel.sh

busybox:
	./scripts/build-busybox.sh

rootfs:
	./scripts/build-rootfs.sh

run:
	./scripts/run.sh

clean:
	rm -rf build
