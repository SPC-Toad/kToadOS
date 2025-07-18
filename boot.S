#define ASM_FILE 1
#include "./multiboot.h"


.section .multiboot
.align MULTIBOOT_HEADER_ALIGN

multiboot_header:
    .long MULTIBOOT2_HEADER_MAGIC     # 0xe85250d6 is the magic number
    .long MULTIBOOT_ARCHITECTURE_I386 # 0 = i386
    .long multiboot_header_end - multiboot_header;# header length
    .long -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))

    .short MULTIBOOT_HEADER_TAG_END             # 0
    .short 0
    .long 8
multiboot_header_end:

.code32
.section .bss
.comm stack, 0x4000

.section .text
.global _start
_start:

multiboot_entry:
    movl $stack+0x4000, %esp
    pushl $0
    popf

    # push the pointer to the multiboot information structure
    pushl %ebx    # GRUB gave this to you — it points to the info struct
    # push in the magic value
    pushl %eax    # GRUB gave this to you — it should be 0x36d76289


    mov $0xB8000, %eax     # VGA framebuffer
    movl $0x0254, (%eax)   # BLK background Green text 'T'
    mov $0xB8002, %eax     # VGA framebuffer
    movl $0x0265, (%eax)   # BLK background Green text 'e'
    mov $0xB8004, %eax     # VGA framebuffer
    movl $0x0273, (%eax)   # BLK background Green text 's'
    mov $0xB8006, %eax     # VGA framebuffer
    movl $0x0274, (%eax)   # BLK background Green text 't'
    mov $0xB8008, %eax     # VGA framebuffer
    movl $0x0220, (%eax)   # BLK background Green text ' '
    mov $0xB8010, %eax     # VGA framebuffer
    movl $0x0231, (%eax)   # BLK background Green text '1'
.hang:
    hlt
    jmp .hang
