require "set"

require "../lex/c/lexer"
require "../ast/node"

# Simple calculator grammar for now
#
# ```
# program    = fn*
# fn         = ident "(" (indent ",")* ")" "{" stmt* "}"
# stmt       = expr ";"
#            | "return" expr ";"
#            | "{" stmt* "}"
#            | asm "{" asm_line* "}"
#            #| "if" "(" expr ")" stmt ("else" stmt)?
#            #| "while" "(" expr ")" stmt
#            #| "for" "(" expr? ";" expr? ";" expr? ")" stmt
# expr       = assign
# assign     = equality ("=" assign)?
# equality   = relational ("==" relational | "!=" relational)*
# relational = add ("<" add | "<=" add | ">" add | ">=" add)*
# add        = mul ("+" mul | "-" mul)*
# mul        = unary ("*" unary | "/" unary)*
# unary      = ("+" | "-")? primary
# primary    = num
#            | ident
#            | ident "(" ( ident ",")* ")"
#            | "(" expr ")"
#
# asm_line   = directive
#            | op_reg_reg
#            | op_reg_imm
# op_reg_reg = op reg "," reg
# op_reg_imm = op reg "," imm
# op         = mv
#            | sub
# reg        = rax
#            | rsi
# imm        = num
# ```
module Z
  class Parser
    class Error < Exception
    end

    alias T = Z::Lex::C::Token::Type
    @tokens : Array(Z::Lex::C::Token) = [] of Z::Lex::C::Token
    @pos : Int32 = 0
    @fn_left_brace_count : Int32 = 0

    @locals : Hash(String, Int32) = {} of String => Int32
    @offset : Int32 = 0

    def initialize(@code : String)
      @lex = Z::Lex::C::Lexer.new(@code)
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
      functions = [] of Ast::Node
      until eof?
        functions << _fn
      end
      Ast::Program.new(functions)
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

      # error "missing `}` after fn `#{name.value}`" unless accept T::RIGHT_BRACE
      Ast::Fn.new(name.value, params, stmts, @offset)
    end

    private def _stmt
      if accept T::RETURN
        n = Ast::Stmt.new(Ast::Return.new(_expr))
      elsif accept T::ASM
        error "expected a `{` after `asm`" unless accept T::LEFT_BRACE

        idents = [] of Ast::Node

        until accept T::RIGHT_BRACE
          error "expected a `}` after `asm`" if eof?

          if i = accept T::IDENT
            idents << Ast::AsmIdent.new(prev.value)
          elsif c = accept T::INT
            idents << Ast::AsmImm.new(prev.value)
          elsif c = accept T::COMMA
            # args 2, or 3
          elsif s = accept T::SEMI
            # idents << curr_node
          else
            error "unexpected #{curr}"
          end
        end
        return Ast::Asm.new(idents)
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
      n = _relational

      loop do
        if accept T::EQ
          n = Ast::BinOp.new(:==, n, _relational)
        elsif accept T::NE
          n = Ast::BinOp.new(:!=, n, _relational)
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
        else
          return n
        end
      end
    end

    private def _unary
      if accept T::PLUS
        return _primary
      elsif accept T::MIN
        return Ast::BinOp.new(:-, Ast::NumberLiteral.new("0"), _primary)
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
        return Ast::Ident.new(prev.value, @locals[prev.value])
      end
      error "expected a parenthesized list, an ident, or a number, got `#{curr.value}`"
    end

    ##

    private def consume(type : T, msg : String? = "")
      unless accept type
        error "expected a #{type}, got `#{curr.value}`"
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
      raise Error.new(msg)
    end
  end
end
