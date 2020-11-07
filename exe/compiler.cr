require "../src/holycc"

code = ARGV[0]

begin
  if code
    cc = Holycc::Compiler.new(code)
    puts cc.compile
  end
rescue e : Holycc::Lexer::Error | Holycc::Parser::Error | Holycc::Compiler::Error
  abort e.message
  # e.backtrace.reverse_each.with_index do |line, index|
  #   puts "\t#{index}: #{line}"
  # end
end
