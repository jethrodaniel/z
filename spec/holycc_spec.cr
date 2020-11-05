require "./spec_helper"

alias T = Holycc::Token::Type

def token(line, col, type, value)
  Holycc::Token.new(line, col, type, value)
end

describe Holycc::Lexer do
  context "#next" do
    it "returns the next token" do
      lex = Holycc::Lexer.new("1 + 2")
      t = token(1, 1, T::INT, "1")
      lex.next.should eq t
      t = token(1, 3, T::PLUS, "+")
      lex.next.should eq t
      t = token(1, 5, T::INT, "2")
      lex.next.should eq t
      lex.next.should eq Iterator::Stop::INSTANCE
    end
  end

 context "#tokens" do
    it "returns all the tokens" do
      lex = Holycc::Lexer.new("9001")
      t = token(1, 1, T::INT, "9001")
      lex.tokens.should eq([t])
    end
  end
end

describe Holycc::Token do
  it ".new" do
    t = token(1, 1, T::INT, "1")
    t.line.should eq 1
    t.col.should eq 1
    t.type.should eq T::INT
    t.value.should eq "1"
  end
end

