require "set"
require "colorize"

require "../lex/lexer"
require "../ast/node"

# Basic recursive-descent parser.
#
# The grammar is as follows (basic EBNF notation)
#
# ```
# program    = (fn | asm)*
# fn         = ident "(" (indent ",")* ")" "{" stmt* "}"
# stmt       = expr ";"
#            | "return" expr ";"
#            #| declaration
#            | "{" stmt* "}"
#            | asm
#            | "if" "(" expr ")" stmt ("else" stmt)?
#            | "while" "(" expr ")" stmt
#            #| "for" "(" expr? ";" expr? ";" expr? ")" stmt
#
# #declaration = type ident ";"
# #            | type ident "=" assign ";"
#
# expr       = assign
# assign     = equality ("=" assign)?
# equality   = logical ("==" logical | "!=" logical)*
# logical    = relational ("&&" relational | "||" relational)*
# relational = add ("<" add | "<=" add | ">" add | ">=" add)*
# add        = mul ("+" mul | "-" mul)*
# mul        = unary ("*" unary | "/" unary)*
# unary      = ("+" | "-")? primary
# primary    = num
#            | ident
#            | ident "(" ( ident ",")* ")"
#            | "(" expr ")"
#
# asm                  = "asm" "{" asm_instruction_list* "}"
# asm_instruction_list = asm_ident
#                      | asm_imm
# ```
module Z
  class Parser
    class Error < Exception
    end

    alias T = Z::Lex::Token::Type
    @tokens : Array(Z::Lex::Token) = [] of Z::Lex::Token
    @pos : Int32 = 0
    @fn_left_brace_count : Int32 = 0

    @locals : Hash(String, Int32) = {} of String => Int32
    @offset : Int32 = 0

    def initialize(@code : String)
      @lex = Z::Lex::Lexer.new(@code)
    end

    def parse
      @tokens = @lex.tokens
      _root
    end

    ##

    private def _root
      return Ast::Program.new([Ast::Nop.new] of Ast::Node) if eof?
      _program
    end

    private def _program
      stmts = [] of Ast::Node
      until eof?
        stmts << _fn_or_asm
      end
      Ast::Program.new(stmts)
    end

    private def _fn_or_asm
      if accept T::ASM
        _asm
      else
        _fn
      end
    end

    private def _fn
      @offset = 0
      @locals.clear
      name = accept T::IDENT
      error "expected a fn name" unless name
      error "missing `(` after fn name" unless accept T::LEFT_PAREN

      params = [] of Ast::FnParam
      while param = accept T::IDENT
        @locals[param.value] ||= (@offset += 8)
        params << Ast::FnParam.new(param.value, @locals[param.value])
        if accept T::COMMA
          next
        elsif accept T::RIGHT_PAREN
          break
        else
          error "expected a `,` and another fn param, or a `)`"
        end
      end
      if params.empty?
        error "missing `)` after fn params" unless accept T::RIGHT_PAREN
      end
      error "missing `{` after fn `#{name.value}`" unless accept T::LEFT_BRACE

      stmts = [] of Ast::Node
      @fn_left_brace_count = 0
      loop do
        break if @fn_left_brace_count.zero? && accept T::RIGHT_BRACE
        stmt = _stmt
        stmts << stmt if stmt
      end

      Ast::Fn.new(name.value, params, stmts, @offset)
    end

    private def _stmt
      if accept T::RETURN
        n = Ast::Stmt.new(Ast::Return.new(_expr))
      elsif accept T::ASM
        return _asm
        # elsif accept T::TYPE
        #   n = Ast::Declaration.new()
      elsif accept T::WHILE
        statements = [] of Ast::Node

        consume T::LEFT_PAREN, "expected `(` after `while`"
        cond = _expr
        consume T::RIGHT_PAREN, "expected `)` after `while`"

        return Ast::While.new(cond, _stmt)
      elsif accept T::IF
        clauses = [] of Ast::Clause

        consume T::LEFT_PAREN, "expected `(` after `if`"
        cond = _expr
        consume T::RIGHT_PAREN, "expected `)` after `if`"
        clauses << Ast::Clause.new(cond, _stmt)

        while accept T::ELSE
          if accept T::IF
            consume T::LEFT_PAREN, "expected `(` after `else if`"
            cond = _expr
            consume T::RIGHT_PAREN, "expected `)` after `else if`"
            clauses << Ast::Clause.new(cond, _stmt)
            next
          end

          default_cond = Ast::Expr.new(Ast::NumberLiteral.new("1"))
          clauses << Ast::Clause.new(default_cond, _stmt)
          break
        end

        return Ast::Stmt.new(Ast::Cond.new(clauses))
      elsif accept T::LEFT_BRACE
        @fn_left_brace_count += 1
        stmts = [] of Ast::Node
        loop do
          if accept T::RIGHT_BRACE
            @fn_left_brace_count -= 1
            return Ast::Block.new(stmts)
          end
          if stmt = _stmt
            stmts << stmt
          else
            break
          end
        end
        return Ast::Block.new(stmts)
      else
        n = Ast::Stmt.new(_expr)
      end
      consume T::SEMI
      n
    end

    # note: the asm token should already be consumed
    private def _asm
      error "expected a `{` after `asm`" unless accept T::LEFT_BRACE

      instructions = [] of Ast::AsmInstructionList
      idents = [] of Ast::AsmIdent | Ast::AsmImm | Ast::AsmLabel

      until accept T::RIGHT_BRACE
        error "expected a `}` after `asm`" if eof?

        if accept T::IDENT
          idents << Ast::AsmIdent.new(prev.value)

          # label:
          #   ...
          if match? T::COLON
            label = Ast::AsmLabel.new(prev.value)
            consume T::COLON
            instructions << Ast::AsmInstructionList.new([label] of Ast::Node)
            idents = [] of Ast::AsmIdent | Ast::AsmImm | Ast::AsmLabel
            # elsif accept T::RIGHT_BRACE
            #   consume T::SEMI, "expected a `;` to terminate assembly line"

            #   instructions << Ast::AsmInstructionList.new(idents)
            #   idents = [] of Ast::AsmIdent | Ast::AsmImm | Ast::AsmLabel
            #   break

            # opcode;
            #
          elsif accept T::SEMI
            instructions << Ast::AsmInstructionList.new(idents)
            idents = [] of Ast::AsmIdent | Ast::AsmImm | Ast::AsmLabel

            # opcode arg
            #
          elsif accept(T::IDENT, T::INT)
            if prev.type.is_a? T::IDENT
              idents << Ast::AsmIdent.new(prev.value)
            elsif prev.type.is_a? T::INT
              idents << Ast::AsmImm.new(prev.value)
            else
              error "prev is #{prev.class}"
            end

            # opcode arg,
            #
            if accept T::COMMA
              # opcode arg, arg
              #
              if accept(T::IDENT, T::INT)
                idents << Ast::AsmIdent.new(prev.value)
              else
                error "expected ident after `,`"
              end
            end

            consume T::SEMI, "expected a `;` to terminate assembly line"

            while accept T::SEMI # eat trailing semicolons
            end

            inst = Ast::AsmInstructionList.new(idents)
            instructions << inst
            idents = [] of Ast::AsmIdent | Ast::AsmImm | Ast::AsmLabel
          end
        else
          error "unexpected #{curr}, expected assembly, got #{prev}"
        end
      end
      Ast::Asm.new(instructions)
    end

    private def _expr
      Ast::Expr.new(_assign)
    end

    private def _assign
      n = _equality

      if accept T::ASSIGN
        if n.is_a?(Ast::Ident)
          n = Ast::Lvar.new(n.value, n.offset)
          return Ast::Assignment.new(n, _assign)
        else
          error "expected left variable, got `#{curr.value}`"
        end
      end
      n
    end

    private def _equality
      n = _logical

      loop do
        if accept T::EQ
          n = Ast::BinOp.new(:==, n, _logical)
        elsif accept T::NE
          n = Ast::BinOp.new(:!=, n, _logical)
        else
          return n
        end
      end
    end

    private def _logical
      return _relational # todo, actually allow logical ops

      n = _relational

      loop do
        if accept T::AND_AND
          n = Ast::BinOp.new(:"&&", n, _relational)
        elsif accept T::BAR_BAR
          n = Ast::BinOp.new(:"||", n, _relational)
        else
          return n
        end
      end
    end

    private def _relational
      n = _add

      loop do
        if accept T::LT
          n = Ast::BinOp.new(:<, n, _add)
        elsif accept T::LE
          n = Ast::BinOp.new(:<=, n, _add)
        elsif accept T::GE
          n = Ast::BinOp.new(:>=, n, _add)
        elsif accept T::GT
          n = Ast::BinOp.new(:>, n, _add)
        else
          return n
        end
      end
    end

    private def _add
      n = _mul

      loop do
        if accept T::PLUS
          n = Ast::BinOp.new(:+, n, _mul)
        elsif accept T::MIN
          n = Ast::BinOp.new(:-, n, _mul)
        else
          return n
        end
      end
    end

    private def _mul
      n = _unary

      loop do
        if accept T::MUL
          n = Ast::BinOp.new(:*, n, _unary)
        elsif accept T::DIV
          n = Ast::BinOp.new(:/, n, _unary)
        elsif accept T::MOD
          n = Ast::BinOp.new(:%, n, _unary)
        else
          return n
        end
      end
    end

    private def _unary
      if accept T::PLUS
        return _primary
      elsif accept T::MIN
        return Ast::Neg.new(_primary)
      end

      _primary
    end

    private def _primary
      if accept T::LEFT_PAREN
        e = _expr
        consume T::RIGHT_PAREN
        return e
      elsif accept T::INT
        return Ast::NumberLiteral.new(prev.value)
      elsif accept T::IDENT
        ident = prev
        if accept T::LEFT_PAREN
          params = [] of Ast::FnArg
          loop do
            if accept T::RIGHT_PAREN
              return Ast::FnCall.new(ident.value, params)
            elsif p = accept T::COMMA
              # skip
            elsif e = _expr
              params << Ast::FnArg.new(e)
            else
              error "expected a closing parenthesis for call to `#{ident.value}()`"
            end
          end
        end
        @locals[prev.value] ||= (@offset += 8)
        return Ast::Ident.new(prev.value, Ast::Types::U64, @locals[prev.value])
      end
      error "expected a parenthesized list, an ident, or a number, got `#{curr.value}`"
    end

    ##

    private def consume(type : T, msg : String? = "")
      unless accept type
        if msg == ""
          error "expected a #{type}, got `#{curr.value}`"
        else
          error msg
        end
      end
    end

    private def accept(*types)
      types.each do |type|
        if match? type
          @pos += 1
          return prev
        end
      end
    end

    private def match?(type)
      return false if eof?
      curr.type == type
    end

    private def eof?
      @pos >= @tokens.size
    end

    private def last?
      @pos == @tokens.size - 1
    end

    private def curr
      error "no tokens available for #curr" if @tokens.size.zero?
      return prev if eof?
      @tokens[@pos]
    end

    private def prev
      error "no tokens available for #prev" if @tokens.empty?
      @tokens[@pos - 1]
    end

    private def error(msg : String)
      lines = @code.split("\n")

      # todo, split out into separate _error with location_ thing
      #
      err = "\n\n#{"error".colorize(:red)}: #{msg.colorize.mode(:bold)}\n"
      err += "#{"-->".colorize(:blue)} #{prev.line}:#{prev.col}"

      space_n = (prev.line + 1).to_s.size
      err += "\n#{" ".ljust(space_n, ' ')}#{" |".colorize(:blue)}\n"

      print_line = ->(n : Int32) {
        err += "#{n.to_s.ljust(space_n, ' ')} | ".colorize(:blue).to_s
        err += lines[n - 1]
        err += "\n"
      }
      print_line.call(prev.line - 1) unless prev.line == 1
      print_line.call(prev.line)
      err += "#{" ".ljust(space_n, ' ')}#{" " * prev.col}  ^".colorize(:red).mode(:bright).to_s
      err += "\n"
      print_line.call(prev.line + 1) if prev.line + 1 < lines.size
      err += "\n\n"
      raise Error.new(err)
    end
  end
end
