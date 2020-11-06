require "../src/holycc"

puts "[parser] 'q' to exit"
prompt = "parser> "

print prompt
while line = gets
  exit if line == "q"

  parser = Holycc::Parser.new(line)

  begin
    puts parser.parse
  rescue e : Holycc::Lexer::Error | Holycc::Parser::Error
    puts e.message
    e.backtrace.reverse_each.with_index do |line, index|
      puts "\t#{index}: #{line}"
    end
  end

  print prompt
end
