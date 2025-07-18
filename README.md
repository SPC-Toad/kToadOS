# kToad OS
kToad OS is my personal project to build a real x86_64 operating system from scratch.
This is a slow-burn, ground-up journey to understand how operating systems truly work—no shortcuts, just raw metal, real memory management, and my own bugs to fix.

I’m documenting everything along the way, and plan to publish an in-depth technical write-up once I complete each major milestone.

|| ⚠️ I’m working on this project whenever I have time ||

## Set up 
- Bootloader: GRUB 2
- Boot Spec: Multiboot 2
- Emulator: QEMU
- Architecture: x86_64 (64-bit long mode)

## Sprint 1 06/26/25 - 07/06/25
- Goal: Build bootable image, verify Multiboot2 compliance, write to screen.
- Disk setup
    - Disk image creation and manual partitioning
    - Installed Grub 2 and configured Multiboot2 header
- Wrote Boot.S with:
    - Multiboot2 compliant headers
    - Display something in VGA memory

### ⚠️ Challenges:
- Triple page fault during initial 64-bit transition attempt => forced restart
- Debugging steps I took
    - Manual Grub shell test by typing in `ls`
        ```sh
        grub> ls
        ```
    - Check the section header and symbol dump to see if multiboot2 header is there:
        ```sh
        readelf -a kernel.elf
        ```
        - Verify presence of .multiboot section
        - Confirm _start and multiboot_header are in first 32 KiB
    - Disassemble the entire binary:
        ```sh
        objdump -D kernel.elf
        ```
        - Confirm correct instruction
        - Makes sure the header is present with right magic number
    - Check symbols thru symbol table
        ```sh 
        nm kernel.elf
        ``` 
        - Ensures _start, multiboot_header, _start64 are present
        - Can be use to verify that `_start` is the ELF entry point
    - Check if you are mounting/updating correct version of kernel.elf
        ```sh
        sha256sum kernel.elf
        ```
        - You should compare with the kernel.elf in the /mnt and your kernel.elf that compiled by looking at the checksum output 
    - You can also use hexdump or xxd to look at the header position in ELF
        ```sh
        hexdump -C kernel.elf | less
        ```

        - Multiboot2 magic number d6 50 52 e8 (in little-endian)
        - should be in the first 32 KiB
        
        ```sh
        xxd kernel.elf | grep d65052e8
        ```
### Visual Demo:

## Sprint 2 7/18/2025 - TBD
- Goal: Enter long mode, build real 64-bit environment, and switch from legacy VGA to framebuffer.

### Planned task
- Set up paging (identity map + higher-half)
- Implement basic MMU support (mmu.h)
- Enable long mode via CR0/CR4/EFER (using MSRs)
- Build a proper GDT (gdt.h)
- Perform 64-bit far jump to _start64

### Kernel.c
- Switch VGA output to framebuffer
- Implement basic `kprintf`
- Basic CLI scaffolding

