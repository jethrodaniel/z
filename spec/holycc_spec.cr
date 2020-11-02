require "./spec_helper"

alias T = Holycc::Token::Type

describe Holycc::Lexer do
  context "#next_token" do
    it "returns the next token" do
      lex = Holycc::Lexer.new("9001")
      t = Holycc::Token.new(1, 1, T::INT, "9001")
      lex.next_token.should eq(t)
    end
  end
end

# alias T = Holycc::Token::Type
describe Holycc::Token do
  it ".new" do
    t = Holycc::Token.new(1, 1, T::INT, "1")
    t.line.should eq 1
    t.col.should eq 1
    t.type.should eq T::INT
    t.value.should eq "1"
  end
end
