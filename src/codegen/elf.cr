# Write a x86_64 ELF binary
#
# See https://www.conradk.com/codebase/2017/05/28/elf-from-scratch/
#
# References:
#
# - `/usr/include/elf.h`

module Elf
  EI_NIDENT = 16

  EI_MAG0 = 0
  ELFMAG0 = 0x7f
  EI_MAG1 = 1
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

class ElfBinary
  def initialize
    @io = IO::Memory.new
  end

  def <<(int)
    @io.write_byte int.to_u8
  end

  def to_s
    @io.to_slice
  end
end

bin = ElfBinary.new

##
# Header

# every ELF file starts with the magic number, then ASCII for 'ELF'
#
# ```
# $ hexdump -C a.out
# 00000000  7f 45 4c 46                                       |.ELF|
# 00000004
# ```
#
bin << Elf::ELFMAG0
bin << Elf::ELFMAG1
bin << Elf::ELFMAG2
bin << Elf::ELFMAG3

# Specify 64-bit output
bin << Elf::ELFCLASS64

# Specify endianess
bin << Elf::ELFDATA2LSB

# Specify elf version
bin << 1

# Specify ABI
bin << Elf::ELFOSABI_SYSV
bin << 0

# Specify padding; todo, is this alway zero?
bin << 0

# Pad out the rest of the `e_ident` header with zeros
(Elf::EI_NIDENT - 10).times { |n| bin << 0 }

##
# segments

# Specify type
bin << Elf::ET_EXEC
bin << 0

# Specify machine
bin << Elf::EM_X86_64
bin << 0

# Specify version
bin << Elf::EV_CURRENT
bin << 0

File.open("a.out", "wb") do |f|
  f.write bin.to_s
end

Process.exec "hexdump", %w[-C a.out]
