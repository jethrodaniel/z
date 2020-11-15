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

    input = if opts[:file]
              File.read(opts[:file].to_s)
            else
              ARGV[0]
            end

    if opts[:lex]
      run_lexer(input)
    elsif opts[:parse]
      run_parser(input)
    elsif opts[:compile]
      run_compiler(input)
    else
      run(input)
    end
  end

  private def self.run_lexer(input)
    lex = Z::Lexer.new(input)
    lex.each { |token| puts token }
  end

  private def self.run_parser(input)
    parser = Z::Parser.new(input)
    puts parser.parse
  end

  private def self.run_compiler(input)
    cc = Z::Compiler.new(input)
    puts cc.compile
  end

  private def self.run(input)
    cc = Z::Compiler.new(input.to_s)
    File.open("z.S", "w") { |f| f.puts cc.compile }
    puts `gcc z.S && ./a.out ; echo $?`
  end
end
