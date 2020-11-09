require "./spec_helper"

describe Holycc::Asm do
  it "build" do
    a = Holycc::Asm::Builder.build do
      global :main
      label :main do
        push 42
  	    pop :rax
        ret
      end
    end

    File.open("a.S", "w") { |f| f.puts a.compile }
    a.compile.should eq <<-ASM
    .intel_syntax noprefix
    .globl main
    main:
      push	42
      pop	rax
      ret

    ASM
    `gcc a.S && ./a.out`
    status = ($?.exit_status >> 8) & 0xff
    status.should eq 42
  end
end
