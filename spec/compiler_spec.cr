require "./spec_helper"

# it_compiles "1 == 1;", 1
# it_compiles "1 != 1;", 0
# it_compiles "1 <= 1;", 1
# it_compiles "1 < 1;", 0
# it_compiles "1 < 2;", 1

Dir
  .glob("./spec/compiler/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      source, ast, _asm, exit_code = File.read(file).split("-" * 80).map(&.strip)

      node = Z::Parser.new(source).parse
      begin
        ast.should eq(node.to_s)
      rescue error
        p ast
        p node.to_s
        fail diff(ast, node.to_s)
      end

      result = Z::Compiler.new(source).compile
      begin
        result.should eq(_asm)
      rescue error
        fail diff(_asm, result)
      end

      f = File.tempfile("z.S") { |f| f.print result }
      res = `gcc #{f.path} && ./a.out; echo $?`.strip
      puts "=> #{res}"
      res.should eq(exit_code)
    end
  end
