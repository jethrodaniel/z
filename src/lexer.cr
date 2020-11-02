require "./token"

module Holycc
  class Lexer
    class Error < Exception
    end

    include Iterator(Token)

    alias T = Token::Type

    def initialize(@code : String)
      @reader = Char::Reader.new(@code)
      @line = 1
      @col = 1
    end

    def next
      loop do
        case c = @reader.current_char
        when '0'..'9'
          v = c.to_s
          while @reader.has_next? && ('0'..'9').includes? @reader.peek_next_char
            v += next_char
          end
          return add_token T::INT, v
        when '+'
          return add_token T::PLUS, c.to_s
        when '-'
          return add_token T::MINUS, c.to_s
        when '\0'
          break
        when ' '
        else
          error "unexpected character `#{c}`"
        end
        if @reader.has_next?
          next_char
        else
          break
        end
      end
      stop
    end

    def tokens
      to_a
    end

    private def next_char
      c = @reader.next_char
      if c == '\n'
        @line += 1
        @col = 1
      else
        @col += 1
      end
      c
    end

    private def add_token(type, value)
      Token.new(@line, @col - value.size + 1, type, value).tap { next_char }
    end

    private def consume_whitespace
      while [' ', '\t', '\n'].includes?(@reader.current_char) &&
            @reader.next_char
      end
    end

    private def error(msg : String)
      raise Error.new("[#{@line}:#{@col}] #{msg}")
    end
  end
end
