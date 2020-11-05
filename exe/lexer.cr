require "../src/holycc"

puts "[lexer] 'q' to exit"
prompt = "lex> "

print prompt
while line = gets
  exit if line == "q"

  lex = Holycc::Lexer.new(line)

  begin
    lex.each do |token|
      puts "=> #{token}"
    end
  rescue e : Holycc::Lexer::Error
    puts e.message
  end

  print prompt
end
