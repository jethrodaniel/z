require "../src/z"

puts "[lexer] 'q' to exit"
prompt = "lex> "

print prompt
while line = gets
  exit if line == "q"

  lex = Z::Lexer.new(line)

  begin
    lex.each do |token|
      puts "=> #{token}"
    end
  rescue e : Z::Lexer::Error
    puts e.message
  end

  print prompt
end
