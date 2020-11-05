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
      _root
    end

    private def _root
      _expr
    end

    private def _expr
      if match?(T::INT)
        Node.new(peek.line, peek.col, peek.type, peek.value)
      end
    end

    ##

    private def match?(*types)
      types.each do |type|
        if check? type
          advance
          return true
        end
      end
      false
    end

    private def check?(type)
      return false if eof?
      peek.type == type
    end

    private def advance
      @pos += 1 if eof?
      prev
    end

    private def eof?
      peek.type == T::EOF
    end

    private def peek
      raise Error.new("no tokens available for #peek") if @tokens.empty?
      @tokens[@pos]
    end

    private def prev
      raise Error.new("no tokens available for #prev") if @tokens.empty?
      @tokens[@pos - 1]
    end

    private def error(msg : String)
      raise Error.new("[#{@line}:#{@col}] #{msg}")
    end
  end
end
