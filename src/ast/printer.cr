require "./node"
require "./visitor"

module Holycc
  module Ast
    class Printer < Visitor
      visit Program do
        args = node.statements.map(&.to_s).join(", ")
        io.print "s(:#{name(node)}, #{args})"
      end

      visit Lvar, Ident, NumberLiteral do
        io.print "s(:#{name(node)}, #{node.value})"
      end

      visit BinOp do
        io.print "s(:#{name(node)}, :#{node.type}, #{node.left}, #{node.right})"
      end

      visit Nop do
        io.print "s(:#{name(node)})"
      end
    end
  end
end
