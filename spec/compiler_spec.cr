require "./spec_helper"

def it_compiles(str, code : Int32)
  it str do
    cc = Holycc::Compiler.new(str)
    a = cc.compile

    File.open("asm.S", "w") { |f| f.puts a }
    `gcc asm.S && cat asm.S && ./a.out`

    # todo: solve this nonsense
    # https://github.com/crystal-lang/crystal/blob/5999ae29beacf4cfd54e232ca83c1a46b79f26a5/src/process/status.cr#L52
    # https://stackoverflow.com/a/808995/7132678
    status = $?.exit_status
    status = (status >> 8) & 0xff
    status.should eq code

    %w[asm.S a.out].each { |f| File.delete f }
  end
end


def it_compiles(str, _asm : String, code : Int32)
  it str do
    cc = Holycc::Compiler.new(str)
    a = cc.compile
    a.should eq _asm

    File.open("asm.S", "w") { |f| f.puts a }
    `gcc asm.S && cat asm.S && ./a.out`

    # todo: solve this nonsense
    # https://github.com/crystal-lang/crystal/blob/5999ae29beacf4cfd54e232ca83c1a46b79f26a5/src/process/status.cr#L52
    # https://stackoverflow.com/a/808995/7132678
    status = $?.exit_status
    status = (status >> 8) & 0xff
    status.should eq code

    %w[asm.S a.out].each { |f| File.delete f }
  end
end

describe Holycc::Compiler do
  it_compiles "1 + 2 * 3", <<-A, 7
  .intel_syntax noprefix  # Use Intel/nasm syntax, not Att/gnu
  .globl main             # standard C entry `_start` expects `main`

  main:
  	push 1        # push `1` onto the stack
  	push 2        # push `2` onto the stack
  	push 3        # push `3` onto the stack
  	pop rdi       # pop a value from the stack into rdi
  	pop rax       # pop a value from the stack into rax
  	imul rax, rdi # multiply rax by rdi
  	push rax
  	pop rdi       # pop a value from the stack into rdi
  	pop rax       # pop a value from the stack into rax
  	add rax, rdi  # add rdi to rax
  	push rax
  	pop rax
  	ret

  A
  it_compiles "1 + -1", 0
  it_compiles "1 + 2 - 3", 0
  it_compiles "4 / 2", 2
  it_compiles "2 * 4", 8
  it_compiles "5+6*7", 47
  it_compiles "5*(9-6)", 15
  it_compiles "(3+5)/2", 4
  it_compiles "1 == 1", 1
  it_compiles "1 != 1", 0
  it_compiles "1 <= 1", 1
  it_compiles "1 < 1",  0
  it_compiles "1 < 2",  1
end
