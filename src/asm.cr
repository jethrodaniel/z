module Z
  # DSL to output assembly
  #
  # ```
  # Asm.new do
  #   directive :global, "main"
  #   label "main" do
  #   end
  # end
  # ```
  module Asm
    struct Builder
      def initialize
        @str = IO::Memory.new
        @indent = 0
        @indent_size = 2
        puts ".intel_syntax noprefix"
      end

      def self.build
        new.build do |builder|
          with builder yield builder
        end
      end

      def build
        with self yield self
        self
      end

      def compile
        @str.to_s
      end

      private def indent
        @indent += 1
        yield
        @indent -= 1
      end

      private def puts(str)
        @str.puts "#{(" " * @indent_size) * @indent}#{str}"
      end

      ##

      def global(sym)
        puts ".globl #{sym}"
      end

      def label(name)
        puts "#{name}:"
        indent do
          yield
        end
      end

      def directive(key, value)
      end

      def mov(from, to)
        puts "mov\t#{from},\t#{to}"
      end

      {% for m in %w[push pop] %}
        def {{ m.id }}(v)
          puts "{{ m.id }}\t#{v}"
        end
      {% end %}

      {% for m in %w[ret] %}
        def {{ m.id }}
          puts "{{ m.id }}"
        end
      {% end %}
    end
  end
end
