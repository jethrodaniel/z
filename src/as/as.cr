module Z
  module Assembler
    class Arch
    end
  end
end

enum Arch
  A_x86_64
  A_aarch64
end

class Target
  def initialize(@arch : Arch)
  end

  def to_s(io)
    io.print "linux-#{@arch.to_s.sub("A_", "")}"
  end
end

class Instruction
  def initialize(@name : String, @target : Target)
  end

  def to_s(io)
    io.puts "[#{@target}] #{@name}"
  end
end

instructions = [
  Instruction.new(
    name: "mov",
    target: Target.new(arch: Arch::A_x86_64)
  )
] of Instruction

instructions.each { |i| puts i }
