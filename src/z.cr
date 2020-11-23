module Z
  VERSION = "0.1.0"
end

require "./syntax/lexer"
require "./syntax/parser"
require "./syntax/ast/dot"
require "./codegen/compiler"
require "./cli"

module Z
  def self.start
    opts = CLI.parse_opts

    return repl(opts) if opts[:interactive]

    input = if opts[:file]
              File.read(opts[:file].to_s)
            else
              ARGV[0]
            end

    if opts[:lex]
      run_lexer(input)
    elsif opts[:parse]
      run_parser(input)
    elsif opts[:dot]
      run_dot(input)
    elsif opts[:compile]
      run_compiler(input)
    else
      run(input)
    end
  end

  private def self.repl(opts)
    puts "z compiler, v#{Z::VERSION}. `q` to quit.\n\n"
    prompt = "(z) "

    loop do
      print prompt
      input = gets

      exit if input == "q"
      next if input.nil? || input == ""

      begin
        if opts[:lex]
          run_lexer(input)
        elsif opts[:parse]
          run_parser(input)
        elsif opts[:dot]
          run_dot(input)
        elsif opts[:compile]
          run_compiler(input)
        else
          run(input)
        end
      rescue e
        puts "#{e.class} #{e.message}"
      end
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

  # ./bin/z -d '1+5;' |tee ast.gv && dot -Tpng ast.gv -o ast.png && firefox ast.png
  private def self.run_dot(input)
    parser = Z::Parser.new(input)
    node = parser.parse
    puts node.accept(Ast::Dot.new, STDOUT)
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
