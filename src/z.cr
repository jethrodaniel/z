module Z
  VERSION = "0.1.0"
end

require "./lexer"
require "./parser"
require "./asm"
require "./compiler"
require "./cli"

module Z
  def self.start
    opts = CLI.parse_opts

    run_lexer if opts[:lex]
    run_parser if opts[:parse]
    run_compiler if opts[:compile]
    run
  end

  private def self.run_lexer
    lex = Z::Lexer.new(ARGV[0])
    lex.each do |token|
      puts "=> #{token}"
    end
  end

  private def self.run_parser
    parser = Z::Parser.new(ARGV[0])
    puts parser.parse
  end

  private def self.run_compiler
    cc = Z::Compiler.new(ARGV[0])
    puts cc.compile
  end

  private def self.run
    cc = Z::Compiler.new(ARGV[0])
    File.open("z.S", "w") { |f| f.puts cc.compile }
    puts `gcc z.S && ./a.out ; echo $?`
  end
end
