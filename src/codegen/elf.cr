# Write a x86_64 ELF binary
#
# See https://www.conradk.com/codebase/2017/05/28/elf-from-scratch/
#
# References:
#
# - `/usr/include/elf.h`

module Elf
  module Index
    MAG0          = 0
    MAG1          = 1
    MAG2          = 2
    MAG3          = 3
    CLASS         = 4
    DATA          = 5
    VERSION       = 6
    OSABI         = 7
    OSABI_VERSION = 8
    PAD = 9
  end

  module Const
    MAG0       = 0x7f
    MAG1       = 'E'.ord
    MAG2       = 'L'.ord
    MAG3       = 'F'.ord
    CLASS64    = 2 # 64-bit objects
    DATA2LSB   = 1 # 2's complement, litte endian
    VERSION    = 1
    OSABI_SYSV = 0
    OSABI_SYSV_VERSION = 0
  end
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

# every ELF file starts with the magic number, then ASCII for 'ELF'
#
# ```
# $ hexdump -C a.out
# 00000000  7f 45 4c 46                                       |.ELF|
# 00000004
# ```
#
bin << Elf::Const::MAG0
bin << Elf::Const::MAG1
bin << Elf::Const::MAG2
bin << Elf::Const::MAG3

# Specify 64-bit output
bin << Elf::Const::CLASS64

# Specify endianess
bin << Elf::Const::DATA2LSB

# todo
bin << Elf::Const::VERSION

# Specify ABI
bin << Elf::Const::OSABI_SYSV
bin << Elf::Const::OSABI_SYSV_VERSION

# Specify padding
bin << 0

File.open("a.out", "wb") do |f|
  f.write bin.to_s
end

Process.exec "hexdump", %w[-C a.out]
