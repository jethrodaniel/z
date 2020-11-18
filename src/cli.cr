require "option_parser"

require "./z"

module Z
  module CLI
    def self.parse_opts
      opts = Hash(Symbol, Bool | String){
        :lex     => false,
        :parse   => false,
        :compile => false,
        :file    => false,
      }

      OptionParser.parse do |parser|
        parser.banner = <<-MSG
          z compiler.

          Usage: z [...options] -f progfile
          Usage: z [...options] [--] 'program'
          MSG

        parser.on "-v", "--version", "Show version" do
          puts "version #{Z::VERSION}"
          exit
        end
        parser.on "-h", "--help", "Show help" do
          puts parser
          exit
        end
        parser.on("-l", "--lex", "Run lexer") { opts[:lex] = true }
        parser.on("-p", "--parse", "Run parser") { opts[:parse] = true }
        parser.on("-c", "--compile", "Run compiler") { opts[:compile] = true }
        parser.on("-f FILE", "--file FILE", "Use FILE as input") do |f|
          opts[:file] = f
        end
        parser.invalid_option do |flag|
          STDERR.puts "ERROR: #{flag} is not a valid option."
          STDERR.puts parser
          exit(1)
        end
      end

      abort <<-ERR if ARGV.empty? && !opts[:file]
        [error] oof, missing 'program'. See `z -h` for usage.
        ERR

      opts
    end
  end
end