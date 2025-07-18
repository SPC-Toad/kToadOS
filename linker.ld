ENTRY(_start)
OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)

SECTIONS {
  . = 1M;

  .multiboot : ALIGN(8)
  {
    KEEP(*(.multiboot))
  }

  .text : ALIGN(8)
  {
    *(.text)
  }

  .rodata : ALIGN(8) { *(.rodata) }
  .data   : ALIGN(8) { *(.data) }
  .bss    : ALIGN(8) { *(.bss) *(COMMON) }
}
