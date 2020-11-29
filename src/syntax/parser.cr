require "set"

require "./lexer"
require "./ast/node"

# Simple calculator grammar for now
#
# ```
# program    = fn*
# fn         = ident "(" (indent ",")* ")" "{" stmt* "}"
# stmt       = expr ";"
#            | "return" expr ";"
#            | "{" stmt* "}"
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
# ```
module Z
  class Parser
    class Error < Exception
    end

    alias T = Token::Type
    @tokens : Array(Token) = [] of Token
    @locals : Hash(String, Int32) = {} of String => Int32
    @offset : Int32 = 0
    @pos : Int32 = 0

    def initialize(@code : String)
      @lex = Lexer.new(@code)
    end

    def parse
      @tokens = @lex.tokens
      _root
    end

    ##

    private def _root
      return Ast::Program.new([Ast::Nop.new] of Ast::Node, @offset) if eof?
      _program
    end

    private def _program
      stmts = [] of Ast::Node
      until eof?
        stmts << _fn
      end
      Ast::Program.new(stmts, @offset)
    end

    private def _fn
      name = accept T::IDENT
      error "expected a fn name" unless name
      error "missing `(` after fn name" unless accept T::LEFT_PAREN

      params = [] of Ast::FnParam
      while param = accept T::IDENT
        params << Ast::FnParam.new(param.value)
        if accept T::COMMA
          next
        else
          error "expected a `,` and another fn param, or a `)`"
        end
      end
      error "missing `)` after fn params" unless accept T::RIGHT_PAREN
      error "missing `{` after fn `#{name.value}`" unless accept T::LEFT_BRACE
      error "missing `}` after fn `#{name.value}`" unless accept T::RIGHT_BRACE
      stmts = [] of Ast::Node
      Ast::Fn.new(name.value, params, stmts)
    end

    private def _stmt
      if accept T::RETURN
        n = Ast::Stmt.new(Ast::Return.new(_expr))
      elsif accept T::LEFT_BRACE
        stmts = [] of Ast::Node
        while stmt = _stmt
          stmts << stmt
          return Ast::Block.new(stmts) if accept T::RIGHT_BRACE
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
            elsif p = accept T::IDENT
              @locals[prev.value] ||= (@offset += 8)
              p = Ast::Ident.new(prev.value, @locals[prev.value])
              params << Ast::FnArg.new(p)
            elsif p = accept T::INT
              p = Ast::NumberLiteral.new(prev.value)
              params << Ast::FnArg.new(p)
            elsif p = accept T::COMMA
              # skip
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
