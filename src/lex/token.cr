module Z::Lex
  abstract class Token
    enum Type
      TODO
    end

    abstract def line
    abstract def col
    abstract def type
    abstract def value

    def inspect(io)
      to_s(io)
    end
  end
end
