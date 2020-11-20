module Z
  module Ast
    abstract class Node
      class Error < Exception; end

      def name
        {{ @type }}.to_s.split("::").last.underscore
      end

      def accept(visitor : Visitor, io : IO)
        visitor.visit self, io
      end
    end

    macro ast_node(name, *properties)
      class {{name.id}} < Node
        {% for property in properties %}
          property {{property.var}} : {{property.type}}
        {% end %}

        def initialize({{
                         *properties.map do |field|
                           "@#{field.id}".id
                         end
                       }})
        end

        def ==(o)
          return false unless o.is_a?({{name.id}})
          {% for prop in properties %}
            return false unless {{prop.var}} == o.{{prop.var}}
          {% end %}
          true
        end

        def inspect(io)
          accept(Printer.new, io)
        end

        def to_s(io)
          inspect(io)
        end
      end
    end

    ast_node Program,
      statements : Array(Node)

    ast_node NumberLiteral,
      value : String

    ast_node Ident,
      value : String,
      offset : Int32

    ast_node Lvar,
      value : String,
      offset : Int32

    ast_node Nop

    ast_node BinOp,
      type : Symbol,
      left : Node,
      right : Node

    ast_node Assignment,
      left : Node,
      right : Node
  end
end
