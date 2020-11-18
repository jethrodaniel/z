require "./spec_helper"
require "../src/ast/shorthand"

def it_prints(node : Z::Ast::Node, expected)
  it node.name do
    printer = Z::Ast::Printer.new
    output = IO::Memory.new
    node.accept(printer, output)
    output.to_s.should eq expected
  end
end

include Z::Ast::Shorthand

describe Z::Ast::Node do
  it "#to_s" do
    num("1").to_s.should eq "s(:number_literal, 1)"
  end
end

describe Z::Ast::Visitor do
  it_prints num("1"), "s(:number_literal, 1)"
  it_prints ident("a", 8), "s(:ident, a)"
  it_prints nop(), "s(:nop)"
  it_prints lvar("a", 8), "s(:lvar, a)"
  it_prints prog(assign(lvar("a", 8), assign(lvar("b", 16), num("2")))), <<-STR
    s(:program, s(:assignment, s(:lvar, a), s(:assignment, s(:lvar, b), s(:number_literal, 2))))
    STR
end
