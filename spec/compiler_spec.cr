require "./spec_helper"
require "../src/codegen/compiler"

def it_compiles(name, code, expected)
  describe Z::Compiler do
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
  ast = files.find { |f| f.ends_with? ".s" }.not_nil!
  it_compiles name, File.read(src).chomp, File.read(ast).chomp
end
