module Holycc
  class Token
    enum Type
      EOF          # \0
      PLUS         # +
      MIN          # -
      DIV          # /
      MUL          # *
      INT          # 124
      LEFT_PAREN   # (
      RIGHT_PAREN  # )
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
      io.puts "[#{line}:#{col}-#{col + value.size}][#{type}, '#{value}']"
    end
  end
end
