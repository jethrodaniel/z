header = LibC::Elf_Phdr.new.tap do |h|
  #define ET_EXEC		2		/* Executable file */
  h.type = 2
end

elf_bin = IO::Memory.new

# every ELF file starts with the magic number, then ASCII for 'ELF'
#
# ```
# $ hexdump -C a.out
# 00000000  7f 45 4c 46                                       |.ELF|
# 00000004
# ```
#
elf_bin.write_byte 0x7f
['E', 'L', 'F'].each { |c| elf_bin << c }

File.open("a.out", "wb") do |f|
  f.write elf_bin.to_slice
end

Process.exec "hexdump", %w[-C a.out]
