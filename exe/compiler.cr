require "../src/compiler"

code = ARGV[0]

begin
  if code
    cc = Z::Compiler.new(code)
    puts cc.compile
  end
rescue e : Z::Lexer::Error | Z::Parser::Error
  abort e.message
  # e.backtrace.reverse_each.with_index do |line, index|
  #   puts "\t#{index}: #{line}"
  # end
end
