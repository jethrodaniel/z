require "./z"

module Z
  class LineEditor
    @line : Int32 = 0
    @col : Int32 = 0

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
      loop do
        buf = [] of Char
        loop do
          c = STDIN.raw(&.read_char).not_nil!

          if !c.control?
            # print c.inspect
            print c
            buf << c
          else
            case c
            when '\u{7f}' # delete
              unless buf.empty?
                buf.pop
                print '\b', ' ', '\b'
              end
            when '\r' # enter
              puts
              return buf.join.to_s
            when '\e'
              esc = [c] of Char
              loop do
                c = STDIN.raw(&.read_char).not_nil!
                # puts " -> #{c.inspect}"
                break if c == '~'
                esc << c
              end
              case esc.join
              when "\e[1" # home
                print "\033[1G"
                return
              # when "\e[4" # end
              #   print "\033[1G"
              #   buf.each { |c| print c }
              #   return
              else
                puts "\nesc => #{esc.map(&.inspect).join}"
              end
            when '\f' # ^l
              buf.size.times {
                print '\b', ' ', '\b'
              }
            else
              puts "\nunknown => #{c.inspect}"
            end
          end
        end
      end
    end
  end
end
