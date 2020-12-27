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

elf_bin = IO::Memory.new

class IO::Memory
end

# every ELF file starts with the magic number, then ASCII for 'ELF'
#
# ```
# $ hexdump -C a.out
# 00000000  7f 45 4c 46                                       |.ELF|
# 00000004
# ```
#
elf_bin.write_byte Elf::Const::MAG0.to_u8
elf_bin.write_byte Elf::Const::MAG1.to_u8
elf_bin.write_byte Elf::Const::MAG2.to_u8
elf_bin.write_byte Elf::Const::MAG3.to_u8

elf_bin.write_byte Elf::Const::CLASS64.to_u8

File.open("a.out", "wb") do |f|
  f.write elf_bin.to_slice
end

Process.exec "hexdump", %w[-C a.out]
