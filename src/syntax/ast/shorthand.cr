module Z
  module Ast
    module Shorthand
      def nop
        Nop.new
      end

      def num(val : String)
        NumberLiteral.new(val)
      end

      def lvar(value : String, offset : Int32)
        Lvar.new(value, offset)
      end

      def ident(value : String, offset : Int32)
        Ident.new(value, offset)
      end

      def assign(left : Node, right : Node)
        Assignment.new(left, right)
      end

      def bi(sym : Symbol, left : Node, right : Node)
        BinOp.new(sym, left, right)
      end

      def prog(*statements : Array(Node))
        Program.new(statements)
      end

      def prog(statement : Node)
        Program.new([statement] of Node)
      end
    end
  end
end