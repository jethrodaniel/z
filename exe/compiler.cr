require "../src/code_gen"

code = ARGV[0]

begin
  if code
    # cc = Holycc::Compiler.new(code)
    # puts cc.compile
    parser = Holycc::Parser.new(code)
    node = parser.parse
    printer = Holycc::CodeGen.new
    output = IO::Memory.new
    node.accept(printer, output)
    puts output
  end
rescue e : Holycc::Lexer::Error | Holycc::Parser::Error
  abort e.message
  # e.backtrace.reverse_each.with_index do |line, index|
  #   puts "\t#{index}: #{line}"
  # end
end
