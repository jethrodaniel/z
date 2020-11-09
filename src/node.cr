module Holycc
  module Ast
    abstract class Node
      class Error < Exception; end
      property :offset

      def name
        {{ @type }}.to_s.split("::").last.underscore
      end

      def to_s(io)
        io.print "s(:#{name})"
      end
    end

    class Program < Node
      property :statements
      @statements : Array(Node) = [] of Node

      def initialize(@statements : Array(Node))
      end

      def initialize(statement : Node)
        @statements << statement
      end

      def to_s(io)
        io.print "s(:#{name}, "
        statements.each.with_index do |s, i|
          io.print(s)
          io.print ", " unless i == statements.size - 1
        end
        io.print ")"
      end

      def ==(o)
        return false unless o.is_a?(Program)
        statements == o.statements
      end
    end


    class NumberLiteral < Node
      property :value

      def initialize(@value : String)
      end

      def to_s(io)
        io.print "s(:#{name}, #{@value})"
      end

      def ==(o)
        return false unless o.is_a?(NumberLiteral)
        value == o.value
      end
    end

    class Ident < Node
      property :value

      def initialize(@value : String)
      end

      def to_s(io)
        io.print "s(:#{name}, #{@value})"
      end

      def ==(o)
        return false unless o.is_a?(Ident)
        value == o.value
      end
    end

    class Lvar < Node
      property :value
      getter :offset

      @value : String
      @offset : Int32

      def initialize(value : Ident)
        @value = value.value
        @offset = (@value[0] - 'a' + 1) * 8
      end

      def ==(o)
        return false unless o.is_a?(Lvar)
        value == o.value &&
          offset == o.offset
      end
    end

    class Nop < Node
    end

    class BinOp < Node
      property :type, :left, :right

      def initialize(@type : Symbol, @left : Node, @right : Node)
      end

      def to_s(io)
        io.print "s(:#{name}, :#{@type}, #{left}, #{right})"
      end

      def ==(o)
        return false unless o.is_a?(BinOp)
        type == o.type &&
          left == o.left &&
          right == o.right
      end
    end
  end
end
