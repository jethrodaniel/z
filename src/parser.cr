require "./lexer"
require "./node"

# expression     → equality ;
# equality       → comparison ( ( "!=" | "==" ) comparison )* ;
# comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
# term           → factor ( ( "-" | "+" ) factor )* ;
# factor         → unary ( ( "/" | "*" ) unary )* ;
# unary          → ( "!" | "-" ) unary
#                | primary ;
# primary        → NUMBER | STRING | "true" | "false" | "nil"
#                | "(" expression ")" ;

# Expr ::= Term ('+' Term | '-' Term)*
# Term ::= Factor ('*' Factor | '/' Factor)*
# Factor ::= ['-'] (Number | '(' Expr ')')
# Number ::= Digit+

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
      # _root
      _term
    end

    ##

    private def _root
      _expr
    end

    private def _expr
      _term
    end

    private def _term
      f = _factor
      # return f if f

      # if match? T::MUL, T::DIV
      #   op = advance
      #   t = _term
      #   Node.new(peek.line, peek.col,
    end

    private def _factor
      n = _number
      return n if n
      consume T::LEFT_PAREN
      e = _number
      error "expected an expression after #{prev.type}" unless e
      consume T::RIGHT_PAREN
      e
    end

    private def _number
      return false if eof?
      if match?(T::INT)
        n = Node.new(peek.line, peek.col, peek.type, peek.value)
        advance
        return n
      end
      nil
    end

    ##

    private def match?(*types)
      types.any? { |type| check? type }
    end

    # private def consume(*types : Array(T), msg : String)
    private def consume(type : T, msg : String? = "")
      if check?(type)
        advance
      else
        error "expected a #{type}, got `#{peek.value}`"
      end
    end

    private def error(msg : String)
      raise Error.new(msg)
    end

    private def check?(type)
      return false if eof?
      peek.type == type
    end

    private def advance
      @pos += 1 unless @pos + 1 >= @tokens.size
      prev
    end

    private def eof?
      @pos >= @tokens.size
    end

    private def peek
      error "no tokens available for #peek" if @tokens.size.zero?
      error "pos #{@pos} out of range for #peek" if eof? # rm
      @tokens[@pos]
    end

    private def prev
      raise Error.new("no tokens available for #prev") if @tokens.empty?
      @tokens[@pos - 1]
    end
  end
end
