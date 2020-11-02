module Holycc
  class Token
    enum Type
      EOF
      PLUS
      MINUS
      INT
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
