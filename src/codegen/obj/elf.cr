# Read and write x86_64 ELF binaries
#
# References:
#
# - `/usr/include/elf.h`
# - https://linuxhint.com/understanding_elf_file_format/
# - https://www.conradk.com/codebase/2017/05/28/elf-from-scratch/

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
    io.puts <<-E
      e_ident
        class    : #{Elf::EI_CLASS_NAMES[e_ident.class]}
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

  def to_s(io)
    io.puts <<-E
      sh_type     : 0x#{sh_type.to_s(16)}
      sh_flags    : 0x#{sh_flags.to_s(16)}
      sh_addr     : 0x#{sh_addr.to_s(16)}
      sh_offset   : 0x#{sh_offset.to_s(16)}
      sh_size     : 0x#{sh_size.to_s(16)}
      sh_info     : 0x#{sh_info.to_s(16)}
      sh_addralign: 0x#{sh_addralign.to_s(16)}
      sh_entsize  : 0x#{sh_entsize.to_s(16)}
    E
  end
end

macro add_n_sections(n)
  # puts "n: #{n}"
  {% for i in (1..n) %}
    custom section_header_{{i.id}} : SectionHeader = SectionHeader.new
  {% end %}
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
    else
      # we may or may not have a program header
      # ensure we have a section header
    end

    @header.e_shnum.times do |n|
      # add section
    end

    # error if anything remains
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

    @sections.each_with_index(1) do |s, i|
      io.puts <<-ELF

      ==> Section ##{i}
      #{s}
      ELF
    end
  end
end
