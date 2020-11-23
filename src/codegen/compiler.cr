require "../syntax/ast/node"
require "../syntax/parser"
require "./codegen"

module Z
  # = Compiler
  #
  # The compiler outputs assembly code from the AST.
  #
  class Compiler
    class Error < Exception
    end

    @node : Ast::Node = Ast::Nop.new

    def initialize(@code : String)
    end

    def compile
      parser = Parser.new(@code)
      node = parser.parse
      printer = CodeGen.new
      output = IO::Memory.new
      node.accept(printer, output)
      output.to_s
    end

    private def error(msg : String)
      raise Error.new(msg)
    end
  end
end
