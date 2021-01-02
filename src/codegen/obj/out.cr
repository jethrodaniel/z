require "./elf"

#
# elf.header.tap do |h|
#  h.e_ident.tap do |e|
#    e.e_class = Elf::ELFCLASS64.to_u8
#    e.endian = Elf::ELFDATA2LSB.to_u8
#    e.version = Elf::EV_CURRENT.to_u8
#  end
# end
#
# puts "==> elf.out"
# o = File.open("elf.out", "w")
# elf.write(o)
