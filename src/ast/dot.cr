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
# ```
# dot -Tpng ast.gv -o ast.png
# ```

require "./node"
require "./visitor"

module Z
  # Print AST in graphviz's `dot` format
  #
  # ```
  # makedot() { make ; z -d "$1" |tee ast.gv && dot -Tpng ast.gv -o ast.png && firefox ast.png; }
  # makedot 'f(){a=b=5;t=b+5;foo();return t+1;}b(x){}'
  # ```
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
        io.puts "  ratio=\"auto\";\n"
        io.puts "  #{name(node)} -> statements;"

        node.statements.each_with_index(1) do |s, i|
          visit(s, io)
        end
        io.puts "}"
      end

      visit Block do
        io.puts "  #{id}; // #{name(node)}"
        io.puts "  #{id} [label=\"#{name(node)}\"];"
        node.statements.each_with_index(1) do |stmt, i|
          io.print "  #{id} ->"
          visit(stmt, io)
        end
      end

      visit FnParam do
        io.puts "  #{id}; // #{name(node)}"
        io.puts "  #{id} [label=\"#{name(node)}, #{node.name}\"];"
      end

      visit Fn do
        io.puts "  statements -> #{node.object_id}; // #{name(node)}"
        io.puts "  #{id} [label=\"#{name(node)}, #{node.name}\"];"

        io.puts "  \"#{id}_params\" [label=\"params\"];"
        io.puts "  #{id} -> \"#{id}_params\";"
        node.params.each do |param|
          io.print "  \"#{id}_params\" ->"
          visit(param, io)
        end

        io.puts "  \"#{id}_statements\" [label=\"statements\"];"
        io.puts "  #{id} -> \"#{id}_statements\";"
        node.statements.each do |stmt|
          io.print "  \"#{id}_statements\" ->"
          visit(stmt, io)
        end
      end

      visit FnCall do
        io.puts "  #{id}; // #{name(node)}"
        io.puts "  #{id} [label=\"#{name(node)}, #{node.name}\"];"
        node.args.each do |arg|
          io.print "  #{id} ->"
          visit(arg, io)
        end
      end

      visit Stmt do
        visit(node.expr, io)
      end

      visit Return do
        io.puts "  #{id}; // #{name(node)}"
        io.puts "  #{id} [label=\"#{name(node)}\"];"
        io.print "  #{id} ->"
        visit(node.value, io)
      end

      visit Expr, FnArg do
        visit(node.value, io)
      end

      visit Lvar, Ident, NumberLiteral do
        io.puts "  #{id}; // #{name(node)}"
        io.puts "  #{id} [label=\"#{name(node)}, #{node.value}\"];"
      end

      visit Assignment do
        io.puts "  #{id}; // #{name(node)}"
        io.puts "  #{id} [label=\"#{name(node)}, =\"];"

        io.print "  #{id} ->"
        visit(node.left, io)

        io.print "  #{id} ->"
        visit(node.right, io)
      end

      visit BinOp do
        io.puts "  #{id}; // #{name(node)}"
        io.puts "  #{id} [label=\"#{name(node)}, #{node.type}\"];"

        io.print "  #{id} ->"
        visit(node.left, io)

        io.print "  #{id} ->"
        visit(node.right, io)
      end

      visit Nop do
        io.puts "  statements -> #{id}; // #{name(node)}"
        io.puts "  #{id}; // #{name(node)}"
        io.puts "  #{id} [label=\"#{name(node)}\"];"
      end

      visit Asm, AsmIdent, AsmImm, AsmInstructionList, AsmLabel do
        raise "err"
      end
    end
  end
end
