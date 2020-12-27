require "colorize"
require "./spec_helper"
require "../src/codegen/compiler"

def it_runs(name, file, expected)
  describe "running" do
    it name do
      output = IO::Memory.new
      err = IO::Memory.new
      Process.run "z",
        ["run", file],
        env: {"PATH" => ENV.fetch("PATH") + ":" + File.join(Dir.current, "bin")},
        output: output,
        error: err
      got = output.to_s.chomp
      puts "ERROR: #{err.to_s.inspect}"
      begin
        expected.should eq(got)
      rescue error
        fail diff(expected, got)
      end
    end
  end
end

for_each_spec do |name, files|
  src = files.find { |f| f.ends_with? ".c" }.not_nil!

  if output = files.find { |f| f.ends_with? ".stdout" }
    it_runs name, src, File.read(output).chomp
  else
    STDERR.puts "missing stdout (`.stdout`) file for `#{src}`".colorize(:red)
  end
end
