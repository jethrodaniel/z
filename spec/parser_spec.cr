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
#
#
#
#
#it_parses <<-C, <<-AST
#f() {
#  // we have comments
#  foo = bar = 42;
#  {
#    foo = 10;
#    baz = 10;
#  }
#  return foo + bar;
#  return bar = 7;
#}
#
#g(){
#  a = b =5;
#  t = b + 5;
#  foo(1, 2);
#  return t+1;
#}
#
#b(x){a;{}}h(){{1;}{{{}}}}
#
#C
#wow
#AST
