# host machine is debian testing, x86-64, this makefile will generate image file for x86
# to build: make 
# to run: make run

all: floppy.img

floppy.img: loader.bin main.bin
	cat loader.bin main.bin > floppy.img

loader.bin: loader.asm
	nasm -o $@ $^

main.bin: runtime.o main.o
	ld -T linker.ld -m elf_i386 -o $@ $^

runtime.o: runtime.asm
	nasm -f elf32 -o $@ $^

main.o: main.rs
	rustc -O --target i386-intel-linux --lib -o $@ -c $^

clean: 
	rm -f *.bin *.o *.img

run: floppy.img
	qemu -fda $^
