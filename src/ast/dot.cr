# = dot
#
# Output an AST in got format
#
# - https://graphviz.org/doc/info/lang.html
# - http://www.graphviz.org/pdf/dotguide.pdf
#
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
      macro id
        node.object_id
      end

      macro label
        "  #{id} [label=\"#{name(node)}\"];"
      end

      visit Program do
        io.puts "digraph G {"
        io.puts "ratio=\"auto\";\n"
        io.puts "  #{name(node)} -> statements;"

        node.statements.each_with_index(1) do |stmt, i|
          io.puts "  statements -> #{stmt.object_id}; // statement"
          # io.puts "  #{stmt.object_id} [label=\"statement\"];"

          stmt.accept(self, io)

          io.puts unless i == node.statements.size - 1
        end
        io.puts "}"
      end

      visit Lvar, Ident, NumberLiteral do
        io.puts "  #{id};"
        io.puts "  #{id} [label=\"#{name(node)}, #{node.value}\"];"
      end

      visit Assignment do
        io.puts "  #{id};"
        io.puts "  #{id} [label=\"#{name(node)}, =\"];"

        io.print "  #{id} ->"
        node.left.accept(self, io)

        io.print "  #{id} ->"
        node.right.accept(self, io)
      end

      visit BinOp do
        io.puts "  #{id};"
        io.puts "  #{id} [label=\"#{name(node)}, #{node.type}\"];"

        io.print "  #{id} ->"
        node.left.accept(self, io)

        io.print "  #{id} ->"
        node.right.accept(self, io)
      end

      visit Nop do
        # io.puts " -> #{name(node)}"
      end
    end
  end
end
