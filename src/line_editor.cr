require "./z"

module Z
  module LineEditor
    def self.readline(prompt)
      loop do
        buf = [] of Char
        loop do
          c = STDIN.raw(&.read_char).not_nil!
          buf << c

          if c.control?
            handle_control_char(c)
            case c
            when '\u{7f}' # delete
              print '\b', ' ', '\b'
            when '\r' # enter
              puts "\nline => #{buf.join}"
              buf = [] of Char
            else
              puts "\nunknown => #{c.inspect}"
            end

            next
          end

          print c
          case c
          when '\r' # enter
            puts "=> #{buf.map(&.inspect).join}"
            buf = [] of Char
          end
          exit if c == 'q'
        end
      end
    end

    private def self.handle_control_char(c)
    end
  end
end
