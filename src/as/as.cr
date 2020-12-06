# machine code: http://ref.x86asm.net/coder64.html
# nasm: https://cs.lmu.edu/~ray/notes/nasmtutorial/

module Z
  module Assembler
    class Arch
    end
  end
end

require "../syntax/token"

class Token < Z::BaseToken
  enum Type
    EOF         # \0
    PLUS        # +
    MIN         # -
    DIV         # /
    MUL         # *
    INT         # 124
    LEFT_PAREN  # (
    RIGHT_PAREN # )
    IDENT       # a = ..., etc
    SEMI        # ;
    COMMA       # ,
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
  ),
] of Instruction

instructions.each { |i| puts i }
