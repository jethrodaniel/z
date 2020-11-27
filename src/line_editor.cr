require "./z"

module Z
  class LineEditor
    @line : Int32 = 0
    @col : Int32 = 0
    @buf : Array(Char) = [] of Char

    HELP = <<-MSG
    line-editor help
    ---------------------------------
    ^l          clear screen
    home        move to beginning of line
    delete      delete a character\n\n
    MSG

    def initialize(@prompt = "input>")
    end

    def readline
      print @prompt, ' '
      @buf = [] of Char
      loop do
        c = STDIN.raw(&.read_char).not_nil!

        # handle_control_char
        if !c.control?
          # print c.inspect
          print c
          @buf << c
        else
          case c
          when '\u{7f}' # delete
            unless @buf.empty?
              @buf.pop
              print '\b', ' ', '\b'
            end
          when '\r' # enter
            puts
            return @buf.join.to_s
          when '\e' # TODO: handle ANSI escapes
            esc = [c] of Char
            loop do
              c = STDIN.raw(&.read_char).not_nil!
              # puts " -> #{c.inspect}"
              break if c == '~'
              esc << c
            end
            # case esc.join
            # when "\e[1" # home
            # when "\e[4" # end
            # else
            #   puts "\nesc => #{esc.map(&.inspect).join}"
            # end
          when '\f' # ^l
            @buf.size.times {
              print '\b', ' ', '\b'
            }
          else
            puts "\nunknown => #{c.inspect}"
          end
        end
      end
    end

    private def handle_control_char(c)
    end
  end
end
