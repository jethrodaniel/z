module Holycc
  class Node
    class Error < Exception
    end

    alias T = Token::Type

    def initialize(@line : Int32, @col : Int32, @type : T, @value : String)
    end

    def to_s(io)
      io.print "s(:#{@type}, #{@value})"
    end
  end
end
