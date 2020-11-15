require "option_parser"

require "./z"

module Z
  module CLI
    def self.parse_opts
      opts = {
        :lex     => false,
        :parse   => false,
        :compile => false,
      }

      OptionParser.parse do |parser|
        parser.banner = "Usage: z [...options] [...files]"

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
      end

      abort "oof, no arguments provided" if ARGV.empty?

      opts
    end
  end
end
