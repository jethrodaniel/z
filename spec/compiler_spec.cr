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
      sample, expected = File.read(file).split("-" * 80).map(&.lstrip)
      result = Z::Compiler.new(sample).compile
      begin
        result.should eq(expected)
      rescue error
        puts "result: #{result.inspect}"
        puts "expected: #{expected.inspect}"
        fail diff(expected, result)
      end
    end
  end
