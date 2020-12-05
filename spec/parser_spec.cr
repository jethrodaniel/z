require "./spec_helper"

def it_parses(name, code, expected)
  describe Z::Parser do
    it name do
      printer = Z::Ast::Printer.new
      output = IO::Memory.new
      node = Z::Parser.new(code).parse
      begin
        expected.should eq(node.to_s)
      rescue error
        fail diff(expected, node.to_s)
      end
    end
  end
end

for_each_spec do |name, files|
  src = files.find { |f| f.ends_with? ".c" }.not_nil!
  ast = files.find { |f| f.ends_with? ".ast" }.not_nil!
  it_parses name, File.read(src).chomp, File.read(ast).chomp
end
