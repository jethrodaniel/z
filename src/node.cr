
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
    end
    class Nop < Node
    end
  end
end
