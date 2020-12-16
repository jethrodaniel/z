module Z::Lex
  class Token
    def to_s(io)
      io.print "[#{line}:#{col}-#{col + value.size}][#{type}, '#{value}']"
    end

    enum Type
      EOF         # \0
      PLUS        # +
      MIN         # -
      DIV         # /
      MUL         # *
      INT         # 124
      LEFT_PAREN  # (
      RIGHT_PAREN # )
      LEFT_BRACE  # {
      RIGHT_BRACE # }
      EQ          # ==
      NE          # !=
      LT          # <
      LE          # <=
      GT          # >
      GE          # >=
      ASSIGN      # =
      IDENT       # a = ..., etc
      SEMI        # ;
      LVAR        # _left variable_
      RETURN      # return
      COMMA       # ,
      ASM         # asm
      COLON       # :
      IF          # if
      ELSE        # else
      WHILE       # while
    end

    property :line, :col, :type, :value

    def initialize(@line : Int32, @col : Int32, @type : Type, @value : String)
    end

    def ==(t : Token)
      line == t.line &&
        col == t.col &&
        type == t.type &&
        value == t.value
    end

    def inspect(io)
      to_s(io)
    end
  end
end
