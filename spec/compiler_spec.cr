require "./spec_helper"

def it_compiles(str, _asm : String, code : Int32)
  it str do
    cc = Holycc::Compiler.new(str)
    a = cc.compile
    a.should eq _asm

    # todo: get executable working from here
    #
    # File.open("asm.S", "w") { |f| f.puts cc.compile }
    # cmd = "gcc asm.S && cat asm.S && ./a.out"
    # status = Process.run(
    #   cmd, nil,
    #   shell: true,
    #   # input: Process::Redirect::Inherit,
    #   # output: Process::Redirect::Inherit,
    #   # error: Process::Redirect::Inherit,
    #   env: {"PATH" => Dir.current}
    # ).exit_status
    # status.should eq code
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
end
