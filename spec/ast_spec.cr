require "./spec_helper"
require "../src/ast/shorthand"

def it_prints(node : Holycc::Ast::Node, expected)
  it node.name do
    printer = Holycc::Ast::Printer.new
    output = IO::Memory.new
    node.accept(printer, output)
    output.to_s.should eq expected
  end
end

include Holycc::Ast::Shorthand

describe Holycc::Ast::Node do
  it "#to_s" do
    num("1").to_s.should eq "s(:number_literal, 1)"
  end
end

describe Holycc::Ast::Visitor do
  it_prints num("1"), "s(:number_literal, 1)"
  it_prints ident("a"), "s(:ident, a)"
end
