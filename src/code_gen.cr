require "./ast/node"
require "./ast/visitor"
require "./parser"

module Holycc
    class CodeGen < Ast::Visitor
      visit Ast::Program do
        io.puts <<-ASM
          # x86_64 assembly

          # Use intel/nasm syntax, not att/gnu
          .intel_syntax noprefix

          # allow loader to find `main`
          .globl main
          main:
          ASM
        node.statements.each { |s| visit(s, io) }
        io.puts  <<-ASM
          \t# pop our return value
          \tpop rax
          \t# pop the stack and jump to that address (i.e, return from function)
          \tret
          ASM
      end

      visit Ast::NumberLiteral do
        io.puts <<-ASM
          \t# push `#{node.value}` onto the stack
          \tpush #{node.value}
          ASM
      end

      visit Ast::BinOp do
        visit(node.left, io)
        visit(node.right, io)

        io.puts <<-ASM
          \t# pop a value from the stack into `rdi`
          \tpop rdi
          \t# pop a value from the stack into `rax`
          \tpop rax
          ASM
        case node.type
        when :+
          io.puts <<-ASM
          \t# add `rdi` to `rax``
          \tadd rax, rdi
          ASM
        end
        io.puts  <<-ASM
          \t# push our return value into `rax`
          \tpush rax
        ASM
      end

      visit Ast::Lvar, Ast::Ident do
        io.puts "s(:#{name(node)}, #{node.value})"
      end


      visit Ast::Nop do
        io.puts "s(:#{name(node)})"
      end
    end
end
