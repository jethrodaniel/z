module Z
  class Token
    enum Type
      EOF         # \0
      PLUS        # +
      MIN         # -
      DIV         # /
      MUL         # *
      INT         # 124
      LEFT_PAREN  # (
      RIGHT_PAREN # )
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

    def to_s(io)
      io.print "[#{line}:#{col}-#{col + value.size}][#{type}, '#{value}']"
    end

    def inspect(io)
      to_s(io)
    end
  end
end
