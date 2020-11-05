require "./spec_helper"

alias N = Holycc::Ast

def it_parses(str, node : N::Node)
  parser = Holycc::Parser.new(str)
  parser.parse.should eq node
end

describe Holycc::Parser do
  it_parses "1",   N::NumberLiteral.new("1")
  it_parses "(1)", N::NumberLiteral.new("1")
end
