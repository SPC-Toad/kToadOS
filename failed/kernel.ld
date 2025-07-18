OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)

ENTRY(_start)
SECTIONS {
    . = 1M;
    _kernel_physical_start = .;

    .text : { 
        KEEP(*(.multiboot))
        *(.text) 
    }

    .rodata : { 
        boot.o (.rodata) 
    }


    .data : { 
        boot.o (.data)
        _edata = .;
    }


    .bss : { 
        boot.o (.bss)
        boot.o (COMMON)
        _end = .;
    }

    _boot_end = .;

    . += 0xFFFFFFFF80000000;

    _kernel_virtual_start = .;

    .text : AT(_boot_end)
    {
        *(.text)
    }

    . = ALIGN(0x1000);

    .rodata : AT( (LOADADDR(.text) + SIZEOF (.text) + 0xFFF) & ~0xFFF ){ 
        *(.rodata) 
    }

    . = ALIGN(0x1000);


    .data : AT( (LOADADDR(.rodata) + SIZEOF (.rodata) + 0xFFF) & ~0xFFF ){ 
        *(.data) 
    }

    . = ALIGN(0x1000);


    .bss : AT( (LOADADDR(.data) + SIZEOF (.data) + 0xFFF) & ~0xFFF ){ 
        *(.bss)
        *(COMMON) 
    }

    _kernel_virtual_end = .;

    _kernel_physical_end = (LOADADDR(.bss) + SIZEOF (.bss) + 0xFFF) & ~0xFFF;
}