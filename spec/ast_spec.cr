require "./spec_helper"

def it_prints_ast(node : Holycc::Ast::Node, expected)
  it "visits the AST" do
    printer = N::Printer.new
    output = IO::Memory.new
    node.accept(printer, output)
    output.to_s.should eq expected
  end
end

describe Holycc::Ast::Node do
  it "#to_s" do
    out = N::NumberLiteral.new("1").to_s
    out.should eq "s(:number_literal, 1)"
  end
end

describe Holycc::Ast::Visitor do
  it_prints_ast N::NumberLiteral.new("1"), <<-OUT
    s(:number_literal, 1)
    OUT
end
