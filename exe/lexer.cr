require "../src/holycc"

puts "[lexer] 'q' to exit"
prompt = "lex> "

print prompt
while line = gets
  exit if line == "q"

  lex = Holycc::Lexer.new(line)

  begin
    while res = lex.next_token
      puts "=> #{res}"
    end
  rescue e : Holycc::Lexer::Error
    puts "#{e.class} #{e.message}"
  end

  print prompt
end
