# disable default rules
.SUFFIXES:

.PHONY: run
.DEFAULT: run

run: clean generate_output_files

clean:
	rm -rf bootloader_files
	rm -rf object_files
	mkdir bootloader_files
	mkdir object_files

generate_output_files: generate_object_files generate_bootloader_files

generate_object_files:  object_files/boot1.o
generate_bootloader_files: bootloader_files/bootloader.bin

qemu-boot-hdd:bootloader_files/bootloader.bin
	qemu-system-x86_64 -drive file=$<,media=disk,format=raw

OBJS:= ./object_files/boot1.o ./object_files/vbe_structure_c.o
ALLFLAGS:= -nostdlib -ffreestanding -std=gnu99 -mno-red-zone -fno-exceptions -nostdlib -Wall -Wextra

object_files/boot1.o: boot1.S
	/home/rakesh/Desktop/cross-compiler/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-as $< -o $@

object_files/vbe_structure_c.o: vbe_structure_c.c
	/home/rakesh/Desktop/cross-compiler/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-gcc -m16 -I . -c $< -o $@ -e 0x0 $(ALLFLAGS)

bootloader_files/bootloader.bin: $(OBJS)
	/home/rakesh/Desktop/cross-compiler/i686-elf-4.9.1-Linux-x86_64/bin/i686-elf-ld $(OBJS) -o $@ -T linker.ld
