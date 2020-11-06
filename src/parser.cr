require "./lexer"
require "./node"

# Simple calculator grammar for now
#
# expr   -> term LEFT_PAREN PLUS term RIGHT_PAREN
#         | term LEFT_PAREN MIN  term RIGHT_PAREN
#         | term
# term   -> factor LEFT_PAREN DIV factor RIGHT_PAREN
#         | factor LEFT_PAREN MUL factor RIGHT_PAREN
#         | factor

# factor -> LEFT_PAREN expr RIGHT_PAREN
#         | number
# number -> INT
#
# Recursive descent works like so
#
# For each rule, create a procedure that attempts to match a non-terminal
# production.
# a -> b c
#    | d
# b -> ckk
module Holycc
  class Parser
    class Error < Exception
    end

    alias T = Token::Type
    @tokens : Array(Token)

    def initialize(@code : String)
      @lex = Lexer.new(@code)
      @tokens = [] of Token
      @pos = 0
    end

    def parse
      @tokens = @lex.tokens
      # @toens << Token.new(0, 0, T::EOF, "\0") unles
      _root
    end

    ##

    private def _root
      return Ast::Nop.new if eof?
      e = _expr
      error "expected EOF, got `#{curr.value}`" unless eof?
      e
    end

    private def _expr
      # _term
      _factor
    end

    private def _term
      f = _factor

      mul = [] of Ast::Node
      div = [] of Ast::Node
      puts curr

      while match? T::MUL, T::DIV
        case advance
        when T::MUL
          mul << _factor
        when T::DIV
          div << _factor
        end
      end

      return f if [mul, div].map(&.size).sum.zero?

      div_seq = Ast::Seq.new(:div, div)
      return div_seq if mul.size.zero?

      mul_seq = Ast::Seq.new(:mul, mul)
      return mul_seq if div.size.zero?

      # Ast::Seq.new(:mul, mul)
    end

    private def _factor
      if accept T::LEFT_PAREN
        e = _number
        # error "expected an expression after #{prev.type}" unless e
        consume T::RIGHT_PAREN
        return e
      end

      n = _number
      return n if n

      error "expected parenthesized list or an integer"
    end

    private def _number
      if accept T::INT
        return Ast::NumberLiteral.new(prev.value)
      end
      error "expected a number, got `#{curr.value}`"
    end

    ##

    # private def consume(*types : Array(T), msg : String)
    private def consume(type : T, msg : String? = "")
      unless accept type
        error "expected a #{type}, got `#{curr.value}`"
      end
    end

    private def accept(type)
      if match? type
        @pos += 1
        prev
      end
    end

    private def match?(type)
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
      error "pos #{@pos} out of range for #curr" if eof? # rm
      @tokens[@pos]
    end

    private def prev
      raise Error.new("no tokens available for #prev") if @tokens.empty?
      @tokens[@pos - 1]
    end

    private def error(msg : String)
      raise Error.new(msg)
    end
  end
end
