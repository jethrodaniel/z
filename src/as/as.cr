module Z
  module Assembler
    class Arch
    end
  end
end

enum Arch
  X86_64
  Aarch64
end

class Target
  def initialize(@arch : Arch)
  end

  def to_s(io)
    io << "linux-#{@arch}"
  end
end

enum Register
  Rax
  Rdi
  Rdx
  Rsi
end

alias ParamType = Register | Int64

class Instruction
  def initialize(@name : String, @target : Target)
  end

  def to_s(io)
    io << "[#{@target}] #{@name}"
  end
end

instructions = [
  Instruction.new(
    name: "mov",
    target: Target.new(arch: Arch::X86_64)
  ),
  Instruction.new(
    name: "syscall",
    target: Target.new(arch: Arch::X86_64)
  ),
  Instruction.new(
    name: "xor",
    target: Target.new(arch: Arch::X86_64)
  )
] of Instruction

instructions.each { |i| puts i }
