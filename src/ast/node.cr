require "./printer"

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
          accept(Printer.new, io).to_s
        end

        def to_s(io)
          inspect(io)
        end
      end
    end

    ast_node Program,
      functions : Array(Node)

    ast_node Fn,
      name : String,
      params : Array(FnParam),
      statements : Array(Node),
      offset : Int32

    ast_node FnParam,
      name : String,
      offset : Int32
    # : type

    ast_node Block,
      statements : Array(Node) # Stmt

    ast_node Stmt,
      expr : Node

    ast_node Expr,
      value : Node

    ast_node Return,
      value : Node

    ast_node FnCall,
      name : String,
      args : Array(FnArg)

    ast_node FnArg,
      value : Node

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

    ast_node Asm,
      instructions : Array(AsmInstructionList)

    ast_node AsmInstructionList,
      instructions : Array(Node)

    ast_node AsmIdent,
      value : String

    ast_node AsmImm,
      value : String
  end
end
