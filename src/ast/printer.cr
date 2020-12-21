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
        out io, "(#{name(node)},\n"
        indent

        node.statements.each_with_index do |s, i|
          visit(s, io)
          io.puts unless i == node.statements.size - 1
        end

        dedent
        io.print ")"
      end

      visit Block do
        if node.statements.empty?
          out io, "(#{name(node)})"
          return
        end

        out io, "(#{name(node)},\n"
        indent

        node.statements.each_with_index do |stmt, i|
          visit(stmt, io)
          io.puts unless i == node.statements.size - 1
        end

        dedent
        io.print ")"
      end

      visit Stmt do
        out io, "(#{name(node)},\n"
        indent

        visit(node.expr, io)

        dedent
        io.print ")"
      end

      visit Cond do
        out io, "(#{name(node)},\n"
        indent

        node.clauses.each_with_index do |c, i|
          visit(c, io)
          io.puts unless i == node.clauses.size - 1
        end

        dedent
        io.print ")"
      end

      visit Clause do
        out io, "(#{name(node)},\n"
        indent

        visit(node.test, io)
        io.puts ","
        visit(node.statement, io)

        dedent
        io.print ")"
      end

      visit While do
        out io, "(#{name(node)},\n"
        indent

        visit(node.test, io)
        io.puts ","
        visit(node.statement, io)

        dedent
        io.print ")"
      end

      visit Fn do
        if node.params.empty? && node.statements.empty?
          out io, "(#{name(node)}, #{node.name})"
          return
        end

        out io, "(#{name(node)}, #{node.name},\n"
        indent

        node.params.each_with_index do |arg, i|
          visit(arg, io)
          io.puts "," if i < node.params.size - 1 || node.statements.size > 0
        end

        node.statements.each_with_index do |stmt, i|
          visit(stmt, io)
          io.puts "," unless i == node.statements.size - 1
        end

        dedent
        io.print ")"
      end

      visit FnParam do
        out io, "(#{name(node)}, #{node.name})"
      end

      visit FnCall do
        if node.args.empty?
          out io, "(#{name(node)}, #{node.name})"
          return
        end

        out io, "(#{name(node)}, #{node.name},\n"
        indent
        node.args.each_with_index do |arg, i|
          visit(arg, io)
          io.puts unless i == node.args.size - 1
        end
        dedent
        io.print ")"
      end

      visit Expr, Return do
        out io, "(#{name(node)},\n"
        indent

        visit(node.value, io)

        dedent
        io.print ")"
      end

      visit FnArg do
        out io, "(#{name(node)},\n"
        indent
        visit(node.value, io)
        dedent
        io.print ")"
      end

      visit Lvar, Ident do
        out io, "(#{name(node)}, #{node.value}@#{node.offset})"
      end

      visit NumberLiteral do
        out io, "(#{name(node)}, #{node.value})"
      end

      visit Assignment do
        out io, "(#{name(node)},\n"
        indent
        visit(node.left, io)

        dedent
        io.puts ","
        indent

        visit(node.right, io)
        dedent
      end

      visit BinOp do
        out io, "(#{name(node)}, #{node.type},\n"
        indent
        visit(node.left, io)

        dedent
        io.puts ","
        indent

        visit(node.right, io)
        dedent
      end

      visit Nop do
        out io, "(#{name(node)})"
      end

      visit Neg do
        out io, "(#{name(node)},\n"
        indent
        visit(node.value, io)
        dedent
        io.print ")"
      end

      visit Asm, AsmInstructionList do
        if node.instructions.empty?
          out io, "(#{name(node)})"
          return
        end
        out io, "(#{name(node)},\n"
        indent

        node.instructions.each_with_index do |inst, i|
          visit(inst, io)
          io.puts "," if i < node.instructions.size - 1
        end

        dedent
        io.print ")"
      end

      visit AsmIdent, AsmImm do
        out io, "(#{name(node)}, #{node.value})"
      end

      visit AsmLabel do
        out io, "(#{name(node)}, #{node.name})"
      end
    end
  end
end
