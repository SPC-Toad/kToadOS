# How to set up your disk image!

🧱 Disk Image Build Plan
1. Create 64MB disk image w/ all 0s:
```bash
    dd if=/dev/zero of=disk.img bs=1M count=128
```
2. Partition it:
```bash
    parted disk.img --script mklabel msdos
    parted disk.img --script mkpart primary ext2 1MiB 100%
```
3. Map it to a loop device:
```bash
    sudo losetup -Pf disk.img
    # Check: ls /dev/loopX and /dev/loopXp1
```
4. Format the partition:
```bash
    sudo mkfs.ext2 /dev/loopXp1
```
5. Mount the filesystem:
```bash
    sudo mount /dev/loopXp1 /mnt
```
6. Install GRUB2 to MBR:
```bash
    sudo grub-install --target=i386-pc --boot-directory=/mnt/boot /dev/loopX
```
7. Place your kernel and config:
```bash
    sudo cp kernel.elf /mnt/boot/
    sudo mkdir -p /mnt/boot/grub
    sudo cp boot/grub/grub.cfg /mnt/boot/grub/
```
8. Unmount and clean up:
```bash
    sudo umount /mnt
    sudo losetup -d /dev/loopX
```