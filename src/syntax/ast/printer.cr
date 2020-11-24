require "./node"
require "./visitor"

module Z
  # Pretty prints the AST as formatted S-expressions.
  module Ast
    class Printer < Visitor
      def initialize
        @indent = 0
      end

      private def indent
        @indent += 2
      end

      private def dedent
        @indent -= 2
      end

      private def out(io, str)
        io.print "#{" " * @indent}#{str}"
      end

      visit Program do
        out io, "s(:#{name(node)},\n"
        indent

        node.statements.each_with_index do |stmt, i|
          stmt.accept(self, io)
          io.puts unless i == node.statements.size - 1
        end

        dedent
        out io, ")"
      end

      visit Block do
        out io, "s(:#{name(node)},\n"
        indent

        node.statements.each_with_index do |stmt, i|
          stmt.accept(self, io)
          io.puts unless i == node.statements.size - 1
        end

        dedent
        out io, ")"
      end

      visit Stmt do
        out io, "s(:#{name(node)},\n"
        indent

        node.expr.accept(self, io)

        dedent
        io.print ")"
      end

      visit FnCall do
        out io, "s(:#{name(node)}, #{node.name},\n"
        indent
        node.args.each_with_index do |arg, i|
          visit(arg, io)
          io.puts unless i == node.args.size - 1
        end
        dedent
        io.print ")"
      end

      visit Expr, Return do
        out io, "s(:#{name(node)},\n"
        indent

        node.value.accept(self, io)

        dedent
        io.print ")"
      end

      visit FnArg do
        out io, "s(:#{name(node)},\n"
        indent
        visit(node.value, io)
        dedent
        io.print ")"
      end

      visit Lvar, Ident do
        out io, "s(:#{name(node)}, #{node.value}@#{node.offset})"
      end

      visit NumberLiteral do
        out io, "s(:#{name(node)}, #{node.value})"
      end

      visit Assignment do
        out io, "s(:#{name(node)},\n"
        indent
        node.left.accept(self, io)

        dedent
        io.puts ","
        indent

        node.right.accept(self, io)
        dedent
      end

      visit BinOp do
        out io, "s(:#{name(node)},\n"
        indent
        out io, "#{node.type},\n"
        node.left.accept(self, io)

        dedent
        io.puts ","
        indent

        node.right.accept(self, io)
        dedent
      end

      visit Nop do
        out io, "s(:#{name(node)})"
      end
    end
  end
end
