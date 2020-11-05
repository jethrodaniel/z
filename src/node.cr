
module Holycc
  module Ast
    abstract class Node
      class Error < Exception; end

      def name
        {{ @type }}.to_s.split("::").last.underscore
      end

      def to_s(io)
        io.print "s(:#{name})"
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
        value == o.value
      end
    end
    class Nop < Node
    end
    class Seq < Node
      property :type, :list
      def initialize(@type : Symbol, @list : Array(Node))
      end
      def to_s(io)
        io.print "s(:#{name}, :#{@type}, #{list})"
      end
    end

  end
end
