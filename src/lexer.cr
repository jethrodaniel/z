module Holycc
  class Token
    enum Type
      EOF
      PLUS
      MIN
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
  class Lexer
    class Error < Exception
    end

    def initialize(@code : String)
      @line = 1
      @col = 1
      @scanner = Char::Reader.new(@code)
    end

    def next_token
      case c = @scanner.current_char
      when '0'..'9'
        v = c.to_s
        while ('0'..'9').includes? @scanner.peek_next_char
          v += next_char
        end
        return Token.new(1, 1, Token::Type::INT, v)
      else
        raise Error.new("[#{@line}:#{@col}] unexpected character `#{c}`")
      end
    end

    private def next_char
      if c = @scanner.next_char == '\n'
        @line += 1
        @col = 1
      else
        @col += 1
      end
      @scanner.current_char
    end
  end
end
