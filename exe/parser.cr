require "../src/z"

puts "[parser] 'q' to exit"
prompt = "parser> "

print prompt
while line = gets
  exit if line == "q"

  parser = Z::Parser.new(line)

  begin
    puts parser.parse
  rescue e : Z::Lexer::Error | Z::Parser::Error
    puts e.message
    # e.backtrace.reverse_each.with_index do |line, index|
    #   puts "\t#{index}: #{line}"
    # end
  end

  print prompt
end
