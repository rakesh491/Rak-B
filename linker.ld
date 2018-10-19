OUTPUT_FORMAT("binary")

SECTIONS {
  . = 0x7c00;

  .boot1 : {
    ./object_files/boot1.o(*text)
  }

  .vbe_structure_c : {
    ./object_files/vbe_structure_c.o(*text)
    ./object_files/vbe_structure_c.o(*rodata)
    ./object_files/vbe_structure_c.o(*data)
    ./object_files/vbe_structure_c.o(*bss)
  }

    /DISCARD/ : {
      *(.eh_frame)
    }

}
