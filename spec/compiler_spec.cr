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
      sample, expected, exit_code = File.read(file).split("-" * 80).map(&.lstrip)
      result = Z::Compiler.new(sample).compile
      begin
        result.should eq(expected)
      rescue error
        fail diff(expected, result)
      end
      f = File.tempfile("z.S") { |f| f.puts result }
      res = `gcc #{f.path} && ./a.out; echo $?`
      puts "=> #{res}"
      res.should eq(exit_code)
    end
  end
