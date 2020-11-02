module Holycc
  class Token
    enum Type
      EOF
      PLUS
      MINUS
      INT
    end

    getter :line, :col, :type, :value

    def initialize(@line : Int32, @col : Int32, @type : Type, @value : String)
    end

    def ==(t : Token)
      line == t.line &&
        col == t.col &&
        type == t.type &&
        value == t.value
    end

    def to_s(io)
      io.puts "[#{line}:#{col}-#{col + value.size}][#{type}, '#{value}']"
    end
  end
end

module Holycc
  class Scanner
    getter :line, :col

    def initialize(code : String)
      @reader = Char::Reader.new(code)
      @line = 0
      @col = 0
    end

    def advance
      c = @col == 0 ? @reader.current_char : @reader.next_char

      if c == '\n'
        @line += 1
        @col = 1
      else
        @col += 1
        @line = 1 if @line.zero?
      end
      c
    end

    def current_char; @reader.current_char; end
    def peek; @reader.peek_next_char; end
  end

  class Lexer
    class Error < Exception
    end

    def initialize(@code : String)
      @scanner = Scanner.new(@code)
    end

    def next_token
      case c = @scanner.advance
      when '0'..'9'
        v = c.to_s
        while ('0'..'9').includes? @scanner.peek
          v += @scanner.advance
        end
        return Token.new(1, 1, Token::Type::INT, v)
      when '+'
        return Token.new(1, 1, Token::Type::PLUS, c.to_s)
      when '-'
        return Token.new(1, 1, Token::Type::MINUS, c.to_s)
      else
        line = @scanner.line
        col = @scanner.col
        raise Error.new("[#{line}:#{col}] unexpected character `#{c}`")
      end
    end
  end
end
