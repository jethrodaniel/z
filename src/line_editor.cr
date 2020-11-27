require "./z"

module Z
  class LineEditor
    @line : Int32 = 0
    @col : Int32 = 0
    @buf : Array(Char) = [] of Char
    @hist : Array(Array(Char)) = [] of Array(Char)

    HELP = <<-MSG
    \nline-editor help
    ----------------------------------------
    ^l        clear screen
    home        ""\n\n
    MSG

    def initialize(@prompt = "input>")
    end

    def readline
      print @prompt, ' '
      @buf.clear
      loop do
        c = STDIN.raw(&.read_char).not_nil!

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
          when '\u{3}' # ^c
            puts "^C"
            return
          when '\u{4}' # ^d
            puts "^D"
            return
          when '\r' # enter
            puts
            return @buf.join.to_s
          when '\e'
            handle_escape_char(c)
          when '\f' # ^l
            clear_line
          else
            puts "\nunknown => #{c.inspect}"
          end
        end
      end
    end

    private def clear_line(clear_prompt = false)
      if clear_prompt
        (@buf.size + @prompt.size + 1).times { print '\b', ' ', '\b' }
      else
        @buf.size.times { print '\b', ' ', '\b' }
      end
      @buf.clear
    end

    private def handle_escape_char(c)
      esc = ['\e'] of Char
      loop do
        c = STDIN.raw(&.read_char).not_nil!
        esc << c
        # puts "\n -> #{c.inspect}, esc: #{esc.map(&.inspect).join}\n"
        case esc.join
        when "\e[[11~"
          return clear_line
          # when "\e[[44~" # end
        end
        esc << c
      end
    end
  end
end
