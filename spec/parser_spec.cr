require "./spec_helper"

alias N = Holycc::Ast

def it_parses(str, node : N::Node)
  parser = Holycc::Parser.new(str)
  parser.parse.should eq node
end

def num(val : String)
  N::NumberLiteral.new(val)
end

describe Holycc::Parser do
  it_parses "1",   num("1")
  it_parses "(1)", num("1")
  it_parses "1 + 2", N::BinOp.new(:+, num("1"), num("2"))
end
