#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <linux/fb.h>

static uint32_t pack(uint8_t r, uint8_t g, uint8_t b,
                     struct fb_var_screeninfo *v)
{
    uint32_t p = 0;

    p |= ((uint32_t)(r >> (8 - v->red.length))) << v->red.offset;
    p |= ((uint32_t)(g >> (8 - v->green.length))) << v->green.offset;
    p |= ((uint32_t)(b >> (8 - v->blue.length))) << v->blue.offset;

    return p;
}

int main(void)
{
    int fd = open("/dev/fb0", O_RDWR);
    if (fd < 0) {
        perror("open /dev/fb0");
        return 1;
    }

    struct fb_fix_screeninfo fix;
    struct fb_var_screeninfo var;

    if (ioctl(fd, FBIOGET_FSCREENINFO, &fix) < 0) {
        perror("FBIOGET_FSCREENINFO");
        return 1;
    }

    if (ioctl(fd, FBIOGET_VSCREENINFO, &var) < 0) {
        perror("FBIOGET_VSCREENINFO");
        return 1;
    }

    printf("Framebuffer: %ux%u, %u bpp, stride %u\n",
           var.xres, var.yres, var.bits_per_pixel, fix.line_length);

    if (var.bits_per_pixel != 32) {
        printf("Expected 32 bpp\n");
        return 1;
    }

    size_t size = fix.line_length * var.yres;

    uint8_t *fb = mmap(NULL, size,
                       PROT_READ | PROT_WRITE,
                       MAP_SHARED, fd, 0);

    if (fb == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    for (uint32_t y = 0; y < var.yres; y++) {
        for (uint32_t x = 0; x < var.xres; x++) {

            uint8_t r = (x * 255) / var.xres;
            uint8_t g = (y * 255) / var.yres;
            uint8_t b = 180;

            uint32_t pixel = pack(r, g, b, &var);

            *(uint32_t *)(fb + y * fix.line_length + x * 4) = pixel;
        }
    }

    munmap(fb, size);
    close(fd);

    printf("MyOS framebuffer rendered successfully!\n");

    return 0;
}
