.PHONY: help setup kernel devboot devboot-run image disk clean

help:
	@echo "setup        install host build tools (uses sudo)"
	@echo "kernel       build the AOS kernel into build/Image"
	@echo "devboot      build kernel + BusyBox initramfs test harness"
	@echo "devboot-run  boot the test harness in QEMU"
	@echo "image        build the AOS OS image with Podman"
	@echo "disk         turn the OS image into build/disk/disk.qcow2 (uses sudo)"
	@echo "clean        remove build/"

setup:
	./devboot/setup.sh

kernel:
	./kernel/build.sh

devboot: kernel
	./devboot/build-busybox.sh
	./devboot/build-rootfs.sh

devboot-run:
	./devboot/run.sh

image:
	./image/build.sh

disk:
	./image/build-disk.sh

clean:
	rm -rf build
