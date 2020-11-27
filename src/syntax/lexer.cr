require "./token"

module Z
  class Lexer
    class Error < Exception
    end

    include Iterator(Token)

    alias T = Token::Type

    IDENT_CHARS = ('A'..'z').to_a + ('0'..'9').to_a + ['_']

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
          return add_token T::MIN, c.to_s
        when '/'
          if @reader.has_next? && @reader.peek_next_char == '/'
            next_char
            while @reader.has_next?
              break if @reader.peek_next_char == '\n'
              next_char
            end
            break unless @reader.has_next?
          else
            return add_token T::DIV, c.to_s
          end
        when '*'
          return add_token T::MUL, c.to_s
        when '('
          return add_token T::LEFT_PAREN, c.to_s
        when ')'
          return add_token T::RIGHT_PAREN, c.to_s
        when '{'
          return add_token T::LEFT_BRACE, c.to_s
        when '}'
          return add_token T::RIGHT_BRACE, c.to_s
        when ';'
          return add_token T::SEMI, c.to_s
        when ','
          return add_token T::COMMA, c.to_s
        when '='
          if @reader.peek_next_char == '='
            next_char
            return add_token T::EQ, "=="
          else
            return add_token T::ASSIGN, "="
          end
        when '!'
          if @reader.peek_next_char == '='
            next_char
            return add_token T::NE, "!="
          else
            raise "! is unsupported"
          end
        when '<'
          if @reader.peek_next_char == '='
            next_char
            return add_token T::LE, "<="
          else
            return add_token T::LT, c.to_s
          end
        when '>'
          if @reader.peek_next_char == '='
            next_char
            return add_token T::GE, ">="
          else
            return add_token T::GT, c.to_s
          end
        when '\0'
          break
        when ' ', '\n' # skip
        when 'a'..'z'
          v = c.to_s
          while @reader.has_next? && IDENT_CHARS.includes? @reader.peek_next_char
            v += next_char
          end
          if v.to_s == "return"
            return add_token T::RETURN, v.to_s
          else
            return add_token T::IDENT, v.to_s
          end
        else
          error "unexpected character `#{c}`"
        end

        if @reader.has_next?
          next_char
        else
          return add_token T::EOF, c.to_s
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
      t = Token.new(@line, @col - value.size + 1, type, value)
      next_char
      t
    end

    private def error(msg : String)
      raise Error.new("[#{@line}:#{@col}] #{msg}")
    end
  end
end
