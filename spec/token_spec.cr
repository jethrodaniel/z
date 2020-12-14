require "./spec_helper"
require "../src/lex/token"

alias T = Z::Lex::Token::Type

def token(line, col, type, value)
  Z::Lex::Token.new(line, col, type, value)
end

describe Z::Lex::Token do
  it ".new" do
    t = token(1, 1, T::INT, "1")
    t.line.should eq 1
    t.col.should eq 1
    t.type.should eq T::INT
    t.value.should eq "1"
  end
end
