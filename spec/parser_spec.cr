require "./spec_helper"

alias N = Holycc::Ast

def it_parses(str, node : N::Node)
  it str do
    parser = Holycc::Parser.new(str)
    parser.parse.should eq node
  end
end

def num(val : String)
  N::NumberLiteral.new(val)
end

def ident(val : String)
  N::Ident.new(val)
end

def lvar(value : String, offset : Int32)
  N::Lvar.new(value, offset)
end

def bi(sym : Symbol, left : N::Node, right : N::Node)
  N::BinOp.new(sym, left, right)
end

def prog(*statements : Array(N::Node))
  N::Program.new(statements)
end

def prog(statement : N::Node)
  N::Program.new([statement] of N::Node)
end

describe Holycc::Parser do
  it_parses "1;",     prog(num("1"))
  it_parses "(1);",   prog(num("1"))
  it_parses "((1));", prog(num("1"))
  it_parses "1 + 2;", prog(bi(:+, num("1"), num("2")))
  it_parses "1 - 2;", prog(bi(:-, num("1"), num("2")))
  it_parses "1 + 2 * 3;",
    prog(
      bi(:+,
        num("1"),
        bi(:*, num("2"), num("3"))))
  it_parses "1 - 2 / 3;",
    prog(
      bi(:-,
        num("1"),
        bi(:/, num("2"), num("3"))))
  it_parses "+1;",  prog(num("1"))
  it_parses "+ 1;", prog(num("1"))
  it_parses "- 1;",    prog(bi(:-,  num("0"), num("1")))
  it_parses "-1;",     prog(bi(:-,  num("0"), num("1")))
  it_parses "1 <= 2;", prog(bi(:<=, num("1"), num("2")))
  it_parses "1 <= 2;", prog(bi(:<=, num("1"), num("2")))
  it_parses "1 < 2;",  prog(bi(:<,  num("1"), num("2")))
  it_parses "1 >= 2;", prog(bi(:>=, num("1"), num("2")))
  it_parses "1 > 2;",  prog(bi(:>,  num("1"), num("2")))
  it_parses "1 == 2;", prog(bi(:==, num("1"), num("2")))
  it_parses "1 == 2;", prog(bi(:==, num("1"), num("2")))
  it_parses "a = 5;",  prog(bi(:"=", lvar("a", 8), num("5")))
  it_parses "42;",     prog(num("42"))
  it_parses "a=b=2;",  prog(bi(:"=", lvar("a", 8), bi(:"=", lvar("b", 16), num("2"))))
end
