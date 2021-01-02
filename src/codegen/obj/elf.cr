# Read and write x86_64 ELF binaries
#
# References:
#
# - `/usr/include/elf.h`
# - http://www.sco.com/developers/gabi/latest/contents.html
# - https://linuxhint.com/understanding_elf_file_format/
# - https://www.conradk.com/codebase/2017/05/28/elf-from-scratch/
# - http://www.skyfree.org/linux/references/ELF_Format.pdf

# note: try and retain header names, for readability's sake
module Elf
  EI_NIDENT = 16

  EI_CLASS       = 4
  ELFCLASS32     = 1
  ELFCLASS64     = 2
  EI_CLASS_NAMES = {
    # ELFCLASS32 => "32-bit",
    ELFCLASS64 => "64-bit",
  }

  EI_DATA       = 5
  ELFDATA2LSB   = 1
  EI_DATA_NAMES = {
    ELFDATA2LSB => "2's complement, little endian",
  }

  EI_VERSION       = 6
  EV_CURRENT       = 1
  EI_VERSION_NAMES = {
    EV_CURRENT => "version #{EV_CURRENT}",
  }

  EI_OSABI       = 7
  ELFOSABI_SYSV  = 0
  EI_OSABI_NAMES = {
    ELFOSABI_SYSV => "SYSV",
  }

  EI_ABIVERSION = 8

  EI_PAD = 9

  ET_NONE  = 0
  ET_REL   = 1
  ET_EXEC  = 2
  ET_DYN   = 3
  ET_CORE  = 4
  ET_NAMES = {
    # ET_NONE => "none",
    ET_REL  => "relocatable",
    ET_EXEC => "executable",
    # ET_DYN  => "dynamic",
    # ET_CORE => "core",
  }
  ET_LOPROC = 0xff00
  ET_HIPROC = 0xffff

  EM_X86_64 = 62
  EM_386    =  3
  EM_NAMES  = {
    EM_X86_64 => "x86_64",
    # EM_386 => "Intel 80386",
  }

  SHT_NULL     =          0
  SHT_PROGBITS =          1
  SHT_SYMTAB   =          2
  SHT_STRTAB   =          3
  SHT_RELA     =          4
  SHT_HASH     =          5
  SHT_DYNAMIC  =          6
  SHT_NOTE     =          7
  SHT_NOBITS   =          8
  SHT_REL      =          9
  SHT_SHLIB    =         10
  SHT_DYNSYM   =         11
  SHT_LOPROC   = 0x70000000
  SHT_HIPROC   = 0x7fffffff

  # SHT_LOUSER = 0x80000000
  # SHT_HIUSER = 0x8fffffff

  def self.sht_names(type)
    types = {
      SHT_NULL     => "Section header table entry unused",
      SHT_PROGBITS => "Program data",
      SHT_SYMTAB   => "Symbol table",
      SHT_STRTAB   => "String table",
      SHT_RELA     => "Relocation entries with addends",
      SHT_HASH     => "Symbol hash table",
      SHT_DYNAMIC  => "Dynamic linking information",
      SHT_NOTE     => "Notes",
      SHT_NOBITS   => "Program space with no data (bss)",
      SHT_REL      => "Relocation entries, no addends",
      SHT_SHLIB    => "Reserved",
      SHT_DYNSYM   => "Dynamic linker symbol table",
    }

    return types[type] if types[type]?

    case type
    when SHT_LOPROC..SHT_HIPROC
      "Processor-specific semantics (0x#{type.to_s(16)})"
    else
      "Unknown (0x#{type.to_s(16)})"
    end
  end

  SHF_WRITE     = (1 << 0)
  SHF_ALLOC     = (1 << 1)
  SHF_EXECINSTR = (1 << 2)

  def self.shf_names(value)
    flags = [] of String

    flags << "Writable" if value & SHF_WRITE
    flags << "Allocated" if value & SHF_ALLOC
    flags << "Executable" if value & SHF_EXECINSTR

    flags.join(", ")
  end
end

require "bindata"

module Elf64
end

class Elf64::Header < BinData
  endian little

  group :e_ident do
    uint8 :mag0, default: 0x7f_u8, verify: ->{ mag0 == 0x7f_u8 }
    uint8 :mag1, default: 'E'.ord, verify: ->{ mag1 == 'E'.ord }
    uint8 :mag2, default: 'L'.ord, verify: ->{ mag2 == 'L'.ord }
    uint8 :mag3, default: 'F'.ord, verify: ->{ mag3 == 'F'.ord }

    uint8 :e_class, verify: ->{
      e_class.in? [Elf::ELFCLASS32, Elf::ELFCLASS64]
    }
    uint8 :endian, verify: ->{
      endian.in? [Elf::ELFDATA2LSB]
    }
    uint8 :version, verify: ->{ version == 1_u8 }
    uint8 :osabi
    uint8 :pad

    uint32 :e_ident_after1, default: 0
    uint16 :e_ident_after2, default: 0
    uint8 :e_ident_after3, default: 0
  end

  uint16 :e_type
  uint16 :e_machine
  uint32 :e_version

  # todo
  uint64 :e_entry
  uint64 :e_phoff
  uint64 :e_shoff

  uint32 :e_flags

  # todo
  uint16 :e_ehsize
  uint16 :e_phentsize
  uint16 :e_phnum
  uint16 :e_shentsize
  uint16 :e_shnum
  uint16 :e_shstrndx

  def to_s(io)
    io.puts <<-E
      e_ident
        class    : #{Elf::EI_CLASS_NAMES[e_ident.e_class]}
        endian   : #{Elf::EI_DATA_NAMES[e_ident.endian]}
        version  : #{Elf::EI_VERSION_NAMES[e_ident.version]}
        osabi    : #{Elf::EI_OSABI_NAMES[e_ident.osabi]}
        pad      : 0x#{e_ident.pad.to_s(16)}
      e_type     : #{Elf::ET_NAMES[e_type]}
      e_machine  : #{Elf::EM_NAMES[e_machine]}
      e_version  : #{Elf::EI_VERSION_NAMES[e_version]}
      e_entry    : 0x#{e_entry.to_s(16)}
      e_phoff    : 0x#{e_phoff.to_s(16)}
      e_shoff    : 0x#{e_shoff.to_s(16)}
      e_flags    : 0x#{e_flags.to_s(16)}
      e_ehsize   : 0x#{e_ehsize.to_s(16)}
      e_phentsize: 0x#{e_phentsize.to_s(16)}
      e_phnum    : 0x#{e_phnum.to_s(16)}
      e_shentsize: 0x#{e_shentsize.to_s(16)}
      e_shnum    : 0x#{e_shnum.to_s(16)}
      e_shstrndx : 0x#{e_shstrndx.to_s(16)}
    E
  end
end

class Elf64::ProgramHeader < BinData
  endian little

  uint32 :p_type
  uint32 :p_flags
  uint64 :p_offset
  uint64 :p_vaddr
  uint64 :p_paddr
  uint32 :p_filesz
  uint32 :p_memsz
  uint32 :p_align

  def to_s(io)
    io.puts <<-E
      p_type     : 0x#{p_type.to_s(16)}
      p_flags    : 0x#{p_flags.to_s(16)}
      p_offset   : 0x#{p_offset.to_s(16)}
      p_vaddr    : 0x#{p_vaddr.to_s(16)}
      p_paddr    : 0x#{p_paddr.to_s(16)}
      p_filesz   : 0x#{p_filesz.to_s(16)}
      p_memsz    : 0x#{p_memsz.to_s(16)}
      p_align    : 0x#{p_align.to_s(16)}
    E
  end
end

class Elf64::SectionHeader < BinData
  endian little

  uint32 :sh_name
  @name : String?
  property :name

  # todo: verify
  uint32 :sh_type

  uint64 :sh_flags
  # bit_field do
  #   bool :flag_write
  #   bool :flag_

  uint64 :sh_addr
  uint64 :sh_offset
  uint64 :sh_size
  uint64 :sh_info
  uint64 :sh_addralign
  uint64 :sh_entsize

  def to_s(io)
    io.puts <<-E
      name        : #{name}
      sh_name     : 0x#{sh_name.to_s(16)}
      sh_type     : #{Elf.sht_names(sh_type)}
      sh_flags    : #{Elf.shf_names(sh_flags)}
      sh_addr     : 0x#{sh_addr.to_s(16)}
      sh_offset   : 0x#{sh_offset.to_s(16)}
      sh_offset   : #{sh_offset}
      sh_size     : 0x#{sh_size.to_s(16)}
      sh_info     : 0x#{sh_info.to_s(16)}
      sh_addralign: 0x#{sh_addralign.to_s(16)}
      sh_entsize  : 0x#{sh_entsize.to_s(16)}
    E
  end
end

class Elf64::Reader
  @header : Header
  @program_header : ProgramHeader?

  def initialize(@io : IO)
    @header = @io.read_bytes(Header)
    @sections = [] of SectionHeader

    # Linking view      Executable view
    #
    # +-------------+   +-------------+
    # | elf header  |   | elf header  |
    # |-------------|   |-------------|
    # | prog header |   | prog header |
    # | table (opt) |   | table       |
    # |-------------|   |-------------|
    # | section 1   |   | segment 1   |
    # |-------------|   |-------------|
    # |    ...      |   |    ...      |
    # |-------------|   |-------------|
    # | section n   |   | segment n   |
    # |-------------|   |-------------|
    # |    ...      |   |    ...      |
    # |-------------|   |-------------|
    # | section     |   | section     |
    # | header      |   | header (opt)|
    # +-------------+   +-------------+

    if @header.e_type == Elf::ET_EXEC
      # ensure we have a program header
      # we may or may not have a section header

      io.seek(@header.e_phoff)
      @program_header = @io.read_bytes(ProgramHeader)

      io.seek(@header.e_shoff)
      @header.e_shnum.times do |n|
        @sections << @io.read_bytes(SectionHeader)
      end

      str_table = @sections[@header.e_shstrndx]

      @sections.each do |s|
        s.name = str_table_value(str_table, s.sh_name)
      end
    else
      # we may or may not have a program header
      # ensure we have a section header
      STDERR.puts "non-exec not supported"
    end

    # error if anything remains
  end

  def str_table_value(section, index)
    @io.seek(section.sh_offset + index)
    @io.gets("\0")
  end

  def to_s(io)
    io.puts <<-ELF
    == elf file ==

    ==> Header
    #{@header}
    ELF

    io.puts <<-ELF if @program_header

    ==> Program Header
    #{@program_header}
    ELF

    @sections.each_with_index do |s, i|
      io.puts <<-ELF

      ==> Section ##{i}
      #{s}
      ELF
    end

    io.puts <<-ELF

    ==> Section Header String Table
    TODO
    ELF
  end
end

class Elf64::Writer
  property :header
  # @header : Header?

  property :program_header
  # @program_header : ProgramHeader?

  property :sections

  def initialize
    @header = Header.new
    @program_header = ProgramHeader.new
    @sections = [] of SectionHeader
  end

  def write(io)
    io.write_bytes(@header)
    # io.write_bytes(@program_header)
  end
end
