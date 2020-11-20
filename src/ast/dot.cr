# https://graphviz.org/doc/info/lang.html
#
# ```
# digraph G {
#     main -> parse -> execute;
#     main -> init;
#     main -> cleanup;
#     execute -> make_string;
#     execute -> printf
#     init -> make_string;
#     main -> printf;
#     execute -> compare;
# }
# ```
#
# ```
# dot -Tpng ast.gv -o ast.png
# ```

require "./node"
require "./visitor"

module Z
  # Print AST in graphviz's `dot` format
  module Ast
    class Dot < Visitor
      @count : Int32 = 1
      visit Program do
        io.puts "digraph G {"
        io.puts "  #{name(node)} -> statements;"

        @count = 1

        node.statements.each_with_index(1) do |stmt, i|
          @label = "statement_#{@count}"
          io.puts "  statements -> #{@label};"
          @count += 1

          stmt.accept(self, io)
          io.puts ";"
          io.puts unless i == node.statements.size - 1
        end
        io.puts "}"
      end

      visit Lvar, Ident, NumberLiteral do
        id = "#{name(node)}_#{@count}"
        io.puts "  #{@label} -> #{id};"
        io.print "  #{id} -> #{node.value}"
      end

      visit Assignment do
        node.left.accept(self, io)
        node.right.accept(self, io)
      end

      visit BinOp do
        id = "#{name(node)}_#{@count}"
        io.puts "  #{@label} -> #{id};"
        @label = "bin_op_#{@count}"
        node.left.accept(self, io)
        @count += 1
        io.puts ";"
        node.right.accept(self, io)
      end

      visit Nop do
        # io.puts " -> #{name(node)}"
      end
    end
  end
end
