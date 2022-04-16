all: kernel bootloader zeroes
	cat boot.bin full_kernel.bin > everything.bin
	cat everything.bin zeroes.bin > os.bin

kernel: main_kernel entry
	i386-elf-ld -o full_kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary

main_kernel: kernel.c
	i386-elf-gcc -ffreestanding -m32 -g -c kernel.c -o kernel.o

entry: kernel_entry.asm
	nasm kernel_entry.asm -f elf -o kernel_entry.o

bootloader: boot.asm
	nasm boot.asm -f bin -o boot.bin

zeroes: zeroes.asm
	nasm zeroes.asm -f bin -o zeroes.bin

run: all
	qemu-system-x86_64 os.bin