require "./parser"
require "./node"

module Holycc
  class Compiler
    class Error < Exception
    end

    alias T = Token::Type
    @node : Ast::Node = Ast::Nop.new

    def initialize(@code : String)
      @parser = Holycc::Parser.new(@code)
    end

    def compile
      @node = @parser.parse
      compile(@node)
    end

    private def compile(node : Ast::Node)
      String.build do |io|
        io.puts <<-A
        .intel_syntax noprefix  # Use Intel/nasm syntax, not Att/gnu
        .globl main             # standard C entry `_start` expects `main`

        main:
        A

        compile_node(node, io)

        io.puts <<-A
        \tpop rax
        \tret
        A
      end
    end

    private def compile_node(node : Ast::Node, io)
      case node
      when Ast::Program
        node.statements.each { |n| compile_node(n, io) }
      when Ast::NumberLiteral
        io.puts "\tpush #{node.value}        # push `#{node.value}` onto the stack"
        return
      when Ast::BinOp
        compile_node(node.left, io)
        compile_node(node.right, io)

        io.puts "\tpop rdi       # pop a value from the stack into rdi"
        io.puts "\tpop rax       # pop a value from the stack into rax"

        case node.type
        when :"="
          io.puts "\tadd rax, rdi  # add rdi to rax"

        when :+
          io.puts "\tadd rax, rdi  # add rdi to rax"
        when :-
          io.puts "\tsub rax, rdi  # subtract rdi from rax"
        when :*
          io.puts "\timul rax, rdi # multiply rax by rdi"
        when :/
          io.puts "\tcqo           # x86_64 div sucks"
          io.puts "\tidiv rdi"
        when :==
          io.puts "\tcmp rax, rdi  # if rax == rdi, set flag"
          io.puts "\tsete al       # set al to 1 if prev cmp was ==, else 0"
          io.puts "\tmovzb rax, al # set rest of rax to al's value"
        when :!=
          io.puts "\tcmp rax, rdi  # if rax == rdi, set flag"
          io.puts "\tsetne al      # set al to 1 if prev cmp was !=, else 0"
          io.puts "\tmovzb rax, al # set rest of rax to al's value"
        when :<
          io.puts "\tcmp rax, rdi  # if rax == rdi, set flag"
          io.puts "\tsetl al       # set al to 1 if prev cmp was <, else 0"
          io.puts "\tmovzb rax, al # set rest of rax to al's value"
        when :<=
          io.puts "\tcmp rax, rdi  # if rax == rdi, set flag"
          io.puts "\tsetle al      # set al to 1 if prev cmp was <=, else 0"
          io.puts "\tmovzb rax, al # set rest of rax to al's value"
          # when :>
          # when :>=
        end
        io.puts "\tpush rax"
      end
    end

    private def error(msg : String)
      raise Error.new(msg)
    end
  end
end
