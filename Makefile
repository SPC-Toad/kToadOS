CC=gcc
AR=ar
CFLAGS=-m64 -O0 -ffreestanding -fno-stack-protector -fno-builtin -nostdinc
LDFLAGS=-m elf_x86_64
LIB=libkernel.a

# compile both c and S (preprocessed file)
# library: kernel.o boot.o
# 	$(AR) rcs $(LIB) kernel.o boot.o
#  -L. -lkernel
%.o: %.c $.S
	$(CC) $(CFLAGS) -c $< -o $@
kernel:
	$(CC) -O0 -c boot.S -o boot.o
#   $(CC) -O0 -c boot.S -o boot.o 
#	$(CC) $(CFLAGS) -c kernel.c -o kernel.o
	ld -T linker.ld -o kernel.elf boot.o

#	ld $(LDFLAGS) -T linker.ld boot.o -o kToad.elf
mount:
	sudo losetup -Pf disk.img && \
	LOOP_DEVICE=$$(losetup -j disk.img | awk -F':' '{print $$1}'); \
	echo "Loop device is: $${LOOP_DEVICE}"; \
	sudo mount $${LOOP_DEVICE}p1 ./mnt
update:
	sudo cp ./kernel.elf ./mnt/boot
umount:
	sudo umount ./mnt && \
	LOOP_DEVICE=$$(losetup -j disk.img | awk -F':' '{print $$1}'); \
	echo "Loop device is: $${LOOP_DEVICE}"; \
	sudo losetup -d $${LOOP_DEVICE}
run:
	qemu-system-x86_64 -drive format=raw,file=disk.img -serial stdio --no-reboot
clean:
	rm -f $(MODULE_OBJS) $(LIB) kToad.elf kernel.o boot.o
