require "./node"

module Holycc
  module Ast
    abstract class Visitor
      macro visit(type)
        def visit(node : {{type}}, io : IO)
          {{yield}}
        end
      end

      macro visit(*types)
        {% for type in types %}
          visit {{type}} do
            {{yield}}
          end
        {% end %}
      end

      private def name(node)
        node.class.name.split("::").last.underscore
      end
    end
  end
end
