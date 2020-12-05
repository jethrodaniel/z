require "./spec_helper"

# it_compiles "1 == 1;", 1
# it_compiles "1 != 1;", 0
# it_compiles "1 <= 1;", 1
# it_compiles "1 < 1;", 0
# it_compiles "1 < 2;", 1

def for_each_spec
Dir
  .glob("./spec/compiler/**/*")
  .select! { |f| File.file?(f) }
  .group_by { |f| File.basename(f).sub(/\..*$/, "") }
  .each do |name, files|
    yield name, files
  end
end
#
#    it file do
#      # asm = File.read(file).split("-" * 80).map(&.strip)
#
#
#      result = Z::Compiler.new(source).compile
#      begin
#        result.should eq(_asm)
#      rescue error
#        fail diff(_asm, result)
#      end
#
#      f = File.tempfile("z.S") { |f| f.print result }
#      res = `gcc #{f.path} && ./a.out; echo $?`.strip
#      puts "=> #{res}"
#      res.should eq(exit_code)
#    end
#  end
