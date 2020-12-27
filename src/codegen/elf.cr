# Write a x86_64 ELF binary
#
# References:
#
# - `/usr/include/elf.h`
# - https://linuxhint.com/understanding_elf_file_format/
# - https://www.conradk.com/codebase/2017/05/28/elf-from-scratch/

# $ gcc -s hi.c ; rake build; hexdump -C a.out |head -n 20; echo ; ../../bin/elf; hexdump -C a.out
# == elf64 ==
#
# ==> Header
#   e_ident:
#     magic: 7f454c46
#     class: 2
#     endian: 1
#     version: 1
#     osabi: 0
#     pad: 0
#   e_type: 2
#   e_machine: 62
#   e_version: 1
#   e_entry: 4195392
#   e_phoff: 64
#   e_shoff: 4448
#   e_flags: 0
#   e_ehsize: 64
#   e_phentsize: 56
#   e_phnum: 9
#   e_shentsize: 64
#   e_shnum: 28
#   e_shstrndx: 27
#
# 00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
# 00000010  02 00 3e 00 01 00 00 00  40 04 40 00 00 00 00 00  |..>.....@.@.....|
# 00000020  40 00 00 00 00 00 00 00  60 11 00 00 00 00 00 00  |@.......`.......|
# 00000030  00 00 00 00 40 00 38 00  09 00 40 00 1c 00 1b 00  |....@.8...@.....|
# 00000040  06 00 00 00 05 00 00 00  40 00 40 00 00 00 00 00  |........@.@.....|
# 00000050  40 00 40 00 00 00 00 00  40 00 40 00 00 00 00 00  |@.@.....@.@.....|
# 00000060  f8 01 00 00 00 00 00 00  f8 01 00 00 00 00 00 00  |................|
# 00000070  08 00 00 00 00 00 00 00  03 00 00 00 40 00 00 00  |............@...|
# 00000080  38 02 00 00 00 00 00 00  38 02 40 00 00 00 00 00  |8.......8.@.....|
# 00000090  38 02 40 00 00 00 00 00  1c 00 00 00 00 00 00 00  |8.@.............|
# 000000a0  1c 00 00 00 00 00 00 00                           |........|
# 000000a8

module Elf
  EI_NIDENT = 16

  EI_CLASS   = 4
  ELFCLASS64 = 2 # 64-bit objects

  EI_DATA     = 5
  ELFDATA2LSB = 1 # 2's complement, litte endian

  EI_VERSION = 6
  EV_CURRENT = 1

  EI_OSABI      = 7
  ELFOSABI_SYSV = 0

  EI_ABIVERSION = 8

  EI_PAD = 9

  # ET_NONE = 0
  # ET_REL = 1
  ET_EXEC = 2
  # ET_DYN = 3
  # ET_CORE = 4

  EM_X86_64 = 62
end

require "bindata"

module Elf64
end

class Elf64::Header < BinData
  endian little

  group :e_ident do
    uint8 :mag0, default: 0x7f_u8 # , verify: ->{ mag0 == 0x7f_u8 }
    uint8 :mag1, default: 'E'.ord
    uint8 :mag2, default: 'L'.ord
    uint8 :mag3, default: 'F'.ord

    uint8 :class, default: Elf::ELFCLASS64
    uint8 :endian, default: Elf::ELFDATA2LSB # todo - use exisiting endian
    uint8 :version, default: 1
    uint8 :osabi, default: Elf::ELFOSABI_SYSV
    uint8 :pad, default: 0 # todo

    uint32 :e_ident_after1, default: 0
    uint16 :e_ident_after2, default: 0
    uint8 :e_ident_after3, default: 0
  end

  uint16 :e_type, default: Elf::ET_EXEC
  uint16 :e_machine, default: Elf::EM_X86_64
  uint32 :e_version, default: Elf::EV_CURRENT

  # todo
  uint64 :e_entry, default: 0x400440
  uint64 :e_phoff, default: 0x40
  uint64 :e_shoff, default: 0x1160

  uint32 :e_flags, default: 0

  # todo
  uint16 :e_ehsize, default: 0x00_40
  uint16 :e_phentsize, default: 0x00_38
  uint16 :e_phnum, default: 0x00_09
  uint16 :e_shentsize, default: 0x00_40
  uint16 :e_shnum, default: 0x00_1c
  uint16 :e_shstrndx, default: 0x00_1b

  def to_s(io)
    magic = [e_ident.mag0, e_ident.mag1, e_ident.mag2, e_ident.mag3].map(&.to_s(16)).join
    io.puts <<-E
      e_ident:
        magic: #{magic}
        class: #{e_ident.class}
        endian: #{e_ident.endian}
        version: #{e_ident.version}
        osabi: #{e_ident.osabi}
        pad: #{e_ident.pad}
      e_type: #{e_type}
      e_machine: #{e_machine}
      e_version: #{e_version}
      e_entry: #{e_entry}
      e_phoff: #{e_phoff}
      e_shoff: #{e_shoff}
      e_flags: #{e_flags}
      e_ehsize: #{e_ehsize}
      e_phentsize: #{e_phentsize}
      e_phnum: #{e_phnum}
      e_shentsize: #{e_shentsize}
      e_shnum: #{e_shnum}
      e_shstrndx: #{e_shstrndx}
    E
  end
end

class Elf64::ProgramHeader < BinData
  endian little

  # todo
  uint32 :p_type, default: 6
  uint32 :p_flags, default: 5
  uint64 :p_offset, default: 0x40_00_40
  uint64 :p_vaddr, default: 0x40_00_40
  uint64 :p_paddr, default: 0x40_00_40
  uint32 :p_filesz, default: 0x01f8
  uint32 :p_memsz, default: 0
  uint32 :p_align, default: 0x01f8
end

class Elf64::SectionHeader < BinData
  endian little

  # todo
  uint32 :sh_name, default: 0

  # define SHT_NOBITS	  8		/* Program space with no data (bss) */
  uint32 :sh_type, default: 8
  uint32 :sh_flags, default: 0
  uint64 :sh_addr, default: 0x04_00_00_00_00_3
  uint64 :sh_offset, default: 0x02_38
  uint64 :sh_size, default: 0x40_02_38
  uint64 :sh_info, default: 0x40_02_38
  uint64 :sh_addralign, default: 0x1c
  uint64 :sh_entsize, default: 0x1c
end

class Elf64::Main < BinData
  endian little

  custom header : Header = Header.new
  # todo: ensure this is located at e_ident.phoff
  custom program_header : ProgramHeader = ProgramHeader.new

  custom section_header : SectionHeader = SectionHeader.new

  def to_s(io)
    io.puts <<-ELF
    == elf64 ==

    ==> Header
    #{header}
    ELF
  end
end

module Elf64
  def self.new
    Main.new
  end
end

elf = Elf64.new.tap do |e|
  # ...
end

# puts elf
o = IO::Memory.new
elf.write(o)
File.open("a.out", "wb") { |f| f << o.to_s }
