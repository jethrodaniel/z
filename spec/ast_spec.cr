require "./spec_helper"

def it_prints(code, expected)
  it code do
    printer = Z::Ast::Printer.new
    output = IO::Memory.new
    node = Z::Parser.new(code).parse
    node.to_s.should eq expected
  end
end

describe Z::Ast::Node do
  it "#to_s is just an #inspect alias" do
    num("1").to_s.should eq "s(:number_literal, 1)"
  end
end

describe Z::Ast::Visitor do
  it_prints "a=5;b=c=4;4+4;3+4-5*(4+2);", <<-Z
    s(:program,
      s(:assignment,
        s(:lvar, a@8),
        s(:number_literal, 5)
      s(:assignment,
        s(:lvar, b@16),
        s(:assignment,
          s(:lvar, c@24),
          s(:number_literal, 4)
      s(:bin_op,
        +,
        s(:number_literal, 4),
        s(:number_literal, 4)
      s(:bin_op,
        -,
        s(:bin_op,
          +,
          s(:number_literal, 3),
          s(:number_literal, 4),
        s(:bin_op,
          *,
          s(:number_literal, 5),
          s(:bin_op,
            +,
            s(:number_literal, 4),
            s(:number_literal, 2))
    Z
end
