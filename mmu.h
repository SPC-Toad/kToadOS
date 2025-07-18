#ifndef MMU_HEADER
#define MMU_HEADER 1

/* 
    Basics of how paging works
    +------------+------------+------------+------------+----------------+
    | 9-bit PML4 | 9-bit PDPT | 9-bit PD   | 9-bit PT   | 12-bit Offset  |
    +------------+------------+------------+------------+----------------+
      Bits 47-39   Bits 38-30   Bits 29-21   Bits 20-12   Bits 11-0

    Each Level maps 512 entries because 2**9 = 512
    Each entry is 8 bytes
    And so 512 * 8 bytes = 4096 bytes = 4Kb and each page is 0x1000 remember?

    For those who are wondering why we are working with 48 bits, 
    it's because we are working with only 4 level paging and support only 48 bits 
    (52 bits possible but no need).

    Anyways, What this means is that when we are given a virtual memory address:
    Ex. 
    0xFFFF800012345678
    That is equal to
    0b1111111111111111100000000000000000010010001101000101011001111000

    Now if you count the binary digits, it is probably 64 bits long (don't waste your time counting).
    But we dont care about first 16 bits (64 - 48). 

    We are about 47th to 12th bits. 

    Now, here is the fun part. 

    SHIFTING to get the number we need for 
    PML4(L4), PDPT(L3), PD(L2), PT(List of entries to physical address)
    
    So for L4 we gonna do some shifting. 
    
        We gonna do 39 bits to the right. 
        Then extract lower 9 bits which is equivalent to (64bit & 2**9) or & (64bit & 0x1ff)
    
    You get the idea?

    Source: Intel 64 and IA32 Arch software dev man Vol 3A (Page 124 for page entries & Page )
    https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-3a-part-1-manual.pdf

*/
#define PAGE_ALIGNMENT  0x1000
#define PAGE_ENTRY_SIZE 8

// LEVEL 4
#define PML4_SIZE       0x1000 // Remember each level is 4096 bytes (512 * 8)
#define PML4_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 39) & 0x1FF)

// LEVEL 3
#define PDPT_SIZE       0x1000
#define PDPT_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 30) & 0x1FF) 

// LEVEL 2
  // Kernel
#define PD_SIZE_KERNEL         0x200000
#define PD_SIZE_KERNEL_SHIFT   21
  // User Land
#define PD_SIZE_USER         0x1000
#define PD_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 21) & 0x1FF) 

// LEVEL 1
#define PT_SIZE         0x1000
#define PT_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 12) & 0x1FF) 


#define PDE_PRESENT               (1 << 0) // PDE_PRESENT: Page is present in memory
#define PDE_READ_WRITE            (1 << 1) // PDE_READ_WRITE: 1 = RW, 0 = read-only
#define PDE_USER_SUDO             (1 << 2)// PDE_USER_SUDO: 1 = user-level, 0 = supervisor-only
#define PDE_ACCESSED              (1 << 5)
#define PDE_PAGE_SIZE             (1 << 7)
// ULL is unsigned Long Long to make it 64 bit :>
#define PDE_EXEC_DISABLE          (1ULL << 63)


// Control Register
#define CR0_PROTECTED_MODE_ENABLE (1 << 0)
#define CR0_EXT_TYPE              (1 << 4)
#define CR0_PAGE_ENABLE           (1 << 31)
#define CR0_64_BIT_KERNEL (CR0_PROTECTED_MODE_ENABLE | CR0_EXT_TYPE | CR0_PAGE_ENABLE)


#define PAGE_FLAGS_KERNEL (PDE_PRESENT | PDE_READ_WRITE)

#define KERNEL_PHYS_BASE 0x0000000000400000
#define KERNEL_VMA_BASE  0xFFFFFFFF80000000

#define KERNEL_PHYS_VMA_OFFSET (KERNEL_VMA_BASE - KERNEL_PHYS_BASE)

#define VIRT_TO_PHYS(addr) ((addr) - KERNEL_PHYS_VMA_OFFSET)
#define PHYS_TO_VIRT(addr) ((addr) + KERNEL_PHYS_VMA_OFFSET)

#endif