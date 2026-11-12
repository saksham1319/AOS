# devboot

A Linux kernel plus a BusyBox initramfs that boots in QEMU in a few seconds. Use it to test
kernel configuration and drivers. It is not the AOS userland; that is `image/`.

`rootfs/` is the initramfs tree, `fbtest.c` draws a test pattern on the framebuffer at boot,
and `busybox.config` is the BusyBox build configuration. BusyBox source is fetched to
`busybox/` (gitignored) by `make setup`.
