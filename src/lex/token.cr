module Z::Lex
  abstract class Token
    enum Type
      TODO
    end

    abstract def line
    abstract def col
    abstract def type
    abstract def value

    def to_s(io)
      io.print "[#{line}:#{col}-#{col + value.size}][#{type}, '#{value}']"
    end

    def inspect(io)
      to_s(io)
    end
  end
end
