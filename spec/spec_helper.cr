require "spec"

# https://github.com/mint-lang/mint/blob/6be6630089058b1a753cb2367469460d37251c45/spec/spec_helper.cr#L17
def diff(a, b)
  file1 = File.tempfile do |f|
    f.puts a.strip
    f.flush
  end
  file2 = File.tempfile do |f|
    f.puts b
    f.flush
  end

  io = IO::Memory.new

  Process.run("git", [
    "--no-pager", "diff", "--no-index", "--color=always",
    file1.path, file2.path,
  ], output: io)

  io.to_s
ensure
  file1.try &.delete
  file2.try &.delete
end

def for_each_spec
  Dir
    .glob("./spec/compiler/**/*")
    .select! { |f| File.file?(f) }
    .group_by { |f| File.basename(f).sub(/\..*$/, "") }
    .each do |name, files|
      # puts "name: #{name}"
      # puts "files: #{files.map(&.to_s).join}"
      yield name, files
    end
end
