require "colorize"
require "./spec_helper"
require "../src/codegen/compiler"

def it_compiles(name, code, expected)
  describe "compiling" do
    it name do
      output = IO::Memory.new
      compiled = Z::Compiler.new(code).compile

      begin
        expected.should eq(compiled)
      rescue error
        fail diff(expected, compiled)
      end
    end
  end
end

for_each_spec do |name, files|
  src = files.find { |f| f.ends_with? ".c" }.not_nil!

  if ast = files.find { |f| f.ends_with? ".s" }
    it_compiles name, File.read(src).chomp, File.read(ast).chomp
  else
    STDERR.puts "missing assembly (`.s`) file for `#{src}`".colorize(:red)
  end
end
