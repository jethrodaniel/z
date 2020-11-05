module Holycc
  class Node
    class Error < Exception
    end

    alias T = Token::Type
    alias Text = String | Symbol

    def initialize(@line : Int32, @col : Int32, @type : Text, @value : Text? = nil)
    end

    def to_s(io)
      io.print "s(:#{@type}"
      if @value
        io.print ", #{@value})"
      else
        io.print ")"
      end
    end
  end
end
