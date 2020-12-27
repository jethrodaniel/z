# Write a x86_64 ELF binary
#
# See https://www.conradk.com/codebase/2017/05/28/elf-from-scratch/
#
# References:
#
# - `/usr/include/elf.h`

module Elf
  EI_NIDENT = 16

  EI_MAG0 =    0
  ELFMAG0 = 0x7f
  EI_MAG1 =    1
  ELFMAG1 = 'E'.ord
  EI_MAG2 = 2
  ELFMAG2 = 'L'.ord
  EI_MAG3 = 3
  ELFMAG3 = 'F'.ord

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

class Elf64 < BinData
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
  uint32 :e_ehsize, default: 0x38_00_40

  def to_s(io)
    magic = [e_ident.mag0, e_ident.mag1, e_ident.mag2, e_ident.mag3].map(&.to_s(16)).join
    io.puts "magic: #{magic}"
    io.puts "class: #{e_ident.class.to_s(16)}"

    io.puts <<-ELF
      magic: #{e_ident.mag0.to_s(16)}
    ELF
  end
end

elf = Elf64.new.tap do |e|
  # ...
end

puts elf
o = IO::Memory.new
elf.write(o)
File.open("a.out", "wb") { |f| f << o.to_s }
