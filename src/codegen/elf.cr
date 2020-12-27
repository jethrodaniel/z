# Write a x86_64 ELF binary
#
# References:
#
# - `/usr/include/elf.h`
# - https://linuxhint.com/understanding_elf_file_format/
# - https://www.conradk.com/codebase/2017/05/28/elf-from-scratch/

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
    return
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
  uint64 :p_offset, default: 0x40
  uint64 :p_vaddr, default: 0x40
  uint64 :p_paddr, default: 0x40
  uint32 :p_filesz, default: 0x01f8
  uint32 :p_memsz, default: 0
  uint32 :p_align, default: 0x01f8
end

class Elf64::Main < BinData
  endian little

  custom header : Header = Header.new
  custom program_header : ProgramHeader = ProgramHeader.new

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

puts elf
o = IO::Memory.new
elf.write(o)
File.open("a.out", "wb") { |f| f << o.to_s }
