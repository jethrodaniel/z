require "./spec_helper"

def _compiles_cmp_run(str, _asm : String, code : Int32)
  it str do
    cc = Z::Compiler.new(str)
    a = cc.compile
    a.should eq(_asm) unless _asm == ""

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
  _compiles_cmp_run(str, _asm, code)
end

def it_compiles(str, code : Int32)
  _compiles_cmp_run(str, "", code)
end

describe Z::Compiler do
  it_compiles "1 + 2 * 3;", <<-A, 7
// x86_64 assembly

// Use intel/nasm syntax, not att/gnu
.intel_syntax noprefix

// allow loader to find `main`
.globl main

// s(:program, s(:bin_op, :+, s(:number_literal, 1), s(:bin_op, :*, s(:number_literal, 2), s(:number_literal, 3))))
main:
	// s(:bin_op, :+, s(:number_literal, 1), s(:bin_op, :*, s(:number_literal, 2), s(:number_literal, 3)))
	// s(:number_literal, 1)
	// push `1` onto the stack
	push 1
	// s(:bin_op, :*, s(:number_literal, 2), s(:number_literal, 3))
	// s(:number_literal, 2)
	// push `2` onto the stack
	push 2
	// s(:number_literal, 3)
	// push `3` onto the stack
	push 3
	// pop a value from the stack into `rdi`
	pop rdi
	// pop a value from the stack into `rax`
	pop rax
	// multiply rax by rdi
	imul rax, rdi
	// push our function return value
	push rax
	// pop a value from the stack into `rdi`
	pop rdi
	// pop a value from the stack into `rax`
	pop rax
	// add `rdi` to `rax`
	add rax, rdi
	// push our function return value
	push rax
	// pop our return value
	pop rax
	// pop the stack and jump to that address (i.e, return from function)
	ret

A
  it_compiles "1 + -1;", 0
  it_compiles "1 + 2 - 3;", 0
  it_compiles "4 / 2;", 2
  it_compiles "2 * 4;", 8
  it_compiles "5+6*7;", 47
  it_compiles "5*(9-6);", 15
  it_compiles "(3+5)/2;", 4
  it_compiles "1 == 1;", 1
  it_compiles "1 != 1;", 0
  it_compiles "1 <= 1;", 1
  it_compiles "1 < 1;",  0
  it_compiles "1 < 2;",  1
  it_compiles "10 + 1 < 2;", 0
end
