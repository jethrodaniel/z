# Write a x86_64 ELF binary
#
# See https://www.conradk.com/codebase/2017/05/28/elf-from-scratch/

module Elf
  module Index
    MAG0 = 0
    MAG1 = 1
    MAG2 = 2
    MAG3 = 3
    CLASS = 4
    DATA = 5
  end

  module Const
    MAG0  = 0x7f
    MAG1  = 'E'.ord
    MAG2  = 'L'.ord
    MAG3  = 'F'.ord
    CLASS64 = 2
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

bin << Elf::Const::CLASS64

File.open("a.out", "wb") do |f|
  f.write bin.to_s
end

Process.exec "hexdump", %w[-C a.out]
