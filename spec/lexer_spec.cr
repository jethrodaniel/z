require "./spec_helper"

def it_lexes(str, expected : Z::Lex::C::Token | Array(Z::Lex::C::Token))
  it str do
    lex = Z::Lex::C::Lexer.new(str)
    t = lex.tokens
    if expected.is_a? Z::Lex::C::Token
      t.first.should eq expected
    else
      t.should eq expected
    end
  end
end

def t(line, col, type, value)
  Z::Lex::C::Token.new(line, col, type, value)
end

describe Z::Lex::C::Lexer do
  it_lexes "1", t(1, 1, T::INT, "1")
  it_lexes "*", t(1, 1, T::MUL, "*")
  it_lexes "/", t(1, 1, T::DIV, "/")
  it_lexes "+", t(1, 1, T::PLUS, "+")
  it_lexes "-", t(1, 1, T::MIN, "-")
  it_lexes "1 + 2 * 3", [
    t(1, 1, T::INT, "1"),
    t(1, 3, T::PLUS, "+"),
    t(1, 5, T::INT, "2"),
    t(1, 7, T::MUL, "*"),
    t(1, 9, T::INT, "3"),
  ]
  it_lexes "<=", t(1, 1, T::LE, "<=")
  it_lexes "<", t(1, 1, T::LT, "<")
  it_lexes ">=", t(1, 1, T::GE, ">=")
  it_lexes ">", t(1, 1, T::GT, ">")
  it_lexes "==", t(1, 1, T::EQ, "==")
  it_lexes "!=", t(1, 1, T::NE, "!=")
  it_lexes "=", t(1, 1, T::ASSIGN, "=")
  it_lexes "z", t(1, 1, T::IDENT, "z")
  it_lexes ";", t(1, 1, T::SEMI, ";")
end
