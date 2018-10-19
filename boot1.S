.global begin

begin:
.code16
ljmp $0x0000,$boot

boot:
  mov %dl,disk
  cli
  movw $0x0000,%ax
  movw %ax,%ss
  movw $0xa000,%ax
  movw %ax,%sp
  movw %ax,%bp
  sti

  movb $0x02,%ah           # load second stage to memory
  movb $12,%al             # numbers of sectors to read into memory
  movb disk,%dl            # sector read from fixed/usb disk ;0 for floppy; 0x80 for hd
  movb $0,%ch              # cylinder number
  movb $0,%dh              # head number
  movb $2,%cl              # sector number
  movw $0x7e00,%bx         # load into es:bx segment :offset of buffer
  int $0x13                # disk I/O interrupt

  jmp second_sector

.equ disk,0x0
.fill 510-(. - begin),1,0
.fill 1,2,0xaa55

#=================================================================
vbe_4f00:
  movw $0x4f00,%ax
  movw $vbe_information_structure,%di
  int $0x10
  pushl $0x0
  pushl $vbe_information_structure
  pushw $0x0000
  call vbe_main_c
  ret

vbe_4f01:
  movw $0x4f01,%ax
  movw $0xc113,%cx                # assuming the mode
  movw $vbe_mode_information_structure,%di
  int $0x10
  pushl $0x1
  pushl $vbe_mode_information_structure
  pushw $0x0000
  call vbe_main_c
  ret

vbe_4f02:
  movw $0x4F02,%ax          # Set VESA Video Mode
  movw $0x103,%bx           # res
  int $0x10                 # Video Interrupt (VBE)
  pushl $0x2
  pushl $0xdead
  pushw $0x0000
  call vbe_main_c
  ret
#==================== Start of the second sector
second_sector:
vbe_information_structure:
.fill 512,1,0

vbe_mode_information_structure:
.fill 512,1,0

sti
movw $0x2401,%ax
int $0x15                 # enable A20 bit

#movw $0x03,%ax
#int $0x10

call vbe_4f01 ################################################################

cmp $0x4f,%ax
je equal
jne n_equal
sti

n_equal:
  movb $'F',%al
  movb $0x0e,%ah
  int $0x10
  jmp ender

equal:
  movb $'R',%al
  movb $0x0e,%ah
  int $0x10
  jmp ender

ender:
  jmp ender
