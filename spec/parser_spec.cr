require "./spec_helper"

def it_parses(code, expected)
  it code do
    printer = Z::Ast::Printer.new
    output = IO::Memory.new
    node = Z::Parser.new(code).parse
    node.to_s.should eq expected
  end
end

describe Z::Parser do
  it_parses "(1==1)+(2<=3)+(3<3)-(1!=0);", <<-Z
    s(:program,
      s(:stmt,
        s(:expr,
          s(:bin_op,
            -,
            s(:bin_op,
              +,
              s(:bin_op,
                +,
                s(:expr,
                  s(:bin_op,
                    ==,
                    s(:number_literal, 1),
                    s(:number_literal, 1)),
                s(:expr,
                  s(:bin_op,
                    <=,
                    s(:number_literal, 2),
                    s(:number_literal, 3)),
              s(:expr,
                s(:bin_op,
                  <,
                  s(:number_literal, 3),
                  s(:number_literal, 3)),
            s(:expr,
              s(:bin_op,
                !=,
                s(:number_literal, 1),
                s(:number_literal, 0)))))
    Z
  it_parses "a=5;b=c=4;4+4;3+4-5*(4+2);", <<-Z
    s(:program,
      s(:stmt,
        s(:expr,
          s(:assignment,
            s(:lvar, a@8),
            s(:number_literal, 5)))
      s(:stmt,
        s(:expr,
          s(:assignment,
            s(:lvar, b@16),
            s(:assignment,
              s(:lvar, c@24),
              s(:number_literal, 4)))
      s(:stmt,
        s(:expr,
          s(:bin_op,
            +,
            s(:number_literal, 4),
            s(:number_literal, 4)))
      s(:stmt,
        s(:expr,
          s(:bin_op,
            -,
            s(:bin_op,
              +,
              s(:number_literal, 3),
              s(:number_literal, 4),
            s(:bin_op,
              *,
              s(:number_literal, 5),
              s(:expr,
                s(:bin_op,
                  +,
                  s(:number_literal, 4),
                  s(:number_literal, 2)))))
    Z
end
