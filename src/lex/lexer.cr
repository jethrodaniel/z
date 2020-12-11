require "./token"

module Z::Lex
  abstract class Lexer
    @line : Int32 = 1
    @col : Int32 = 1

    class Error < Exception
    end

    # identifiers start with a letter, then zero or more of these
    IDENT_CHARS = ('A'..'z').to_a + ('0'..'9').to_a + ['_']

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
  end
end
