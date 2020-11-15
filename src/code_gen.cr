require "./ast/node"
require "./ast/visitor"
require "./parser"

module Z
    class CodeGen < Ast::Visitor
      visit Ast::Program do
        args = node.statements.map(&.to_s).join(", ")
        io.puts <<-ASM
          // x86_64 assembly

          // Use intel/nasm syntax, not att/gnu
          .intel_syntax noprefix

          // allow loader to find `main`
          .globl main

          // s(:#{name(node)}, #{args})
          main:
          ASM
        node.statements.each do |s|
          visit(s, io)
        end
        io.puts  <<-ASM
          \t// pop our return value
          \tpop rax
          \t// pop the stack and jump to that address (i.e, return from function)
          \tret
          ASM
      end

      visit Ast::NumberLiteral do
        io.puts <<-ASM
          \t// s(:#{name(node)}, #{node.value})
          \t// push `#{node.value}` onto the stack
          \tpush #{node.value}
          ASM
      end

      visit Ast::BinOp do
        io.puts "\t// s(:#{name(node)}, :#{node.type}, #{node.left}, #{node.right})"

        visit(node.left, io)
        visit(node.right, io)

        io.puts <<-ASM
          \t// pop a value from the stack into `rdi`
          \tpop rdi
          \t// pop a value from the stack into `rax`
          \tpop rax
          ASM
        case node.type
        when :+
          io.puts <<-ASM
            \t// add `rdi` to `rax`
            \tadd rax, rdi
            ASM
        when :-
          io.puts <<-ASM
            \t// subtract rdi from rax
            \tsub rax, rdi
            ASM
        when :*
          io.puts <<-ASM
            \t// multiply rax by rdi
            \timul rax, rdi
            ASM
        when :/
          io.puts <<-ASM
            \t// x86_64 div sucks
            \tcqo
            \tidiv rdi
            ASM
        when :==
          io.puts <<-ASM
            \t// if rax == rdi, set flag"
            \tcmp rax, rdi
            \t// set al to 1 if prev cmp was ==, else 0 (first 8 bits)"
            \tsete al
            \t// set rest of rax to al's value (the other 54 bits)"
            \tmovzb rax, al
            ASM
        when :!=
          io.puts <<-ASM
            \t// if rax != rdi, set flag"
            \tcmp rax, rdi
            \t// set al to 1 if prev cmp was !=, else 0 (first 8 bits)"
            \tsetne al
            \t// set rest of rax to al's value (the other 54 bits)"
            \tmovzb rax, al
            ASM
        when :<
          io.puts <<-ASM
            \t// if rax < rdi, set flag
            \tcmp rax, rdi
            \t// set al to 1 if prev cmp was <, else 0
            \tsetl al
            \t// set rest of rax to al's value
            \tmovzb rax, al
          ASM
        when :<=
          io.puts <<-ASM
            \t// if rax <= rdi, set flag
            \tcmp rax, rdi
            \t// set al to 1 if prev cmp was <=, else 0
            \tsetle al
            \t// set rest of rax to al's value
            \tmovzb rax, al
          ASM
        end
        io.puts  <<-ASM
          \t// push our function return value
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
