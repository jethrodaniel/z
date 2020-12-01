require "./z"

module Z
  class LineEditor
    HELP = <<-MSG
    \nline-editor help
    ----------------------------------------
    ^l        clear screen
    home        ""\n\n
    MSG

    def initialize(@prompt = "input> ")
      @line = 0
      @col = 0
      @buf = [] of Char
      @hist = [] of Array(Char)
      @last_newline_col = 0
      # @lines = [] of Array(Array(Char))
    end

    def readline
      print @prompt
      reset

      while c = STDIN.raw(&.read_char).not_nil!
        if c.control?
          case c
          when '\u{7f}'
            delete_char
          when '\u{3}'
            puts "^C"
            return
          when '\u{4}'
            puts "^D"
            return
          when '\u{e}' # ^n
            @buf << '\n'
            increment_line
          when '\r' # enter
            increment_line
            add_to_history
            return @buf.join.to_s
          when '\e'
            handle_escape_char
          when '\f' # ^l
            clear_line
          else
            puts "\nunknown => #{c.inspect}"
          end
        else
          handle_regular_char(c)
        end
      end
    end

    def inspect(io)
      io.puts <<-ED
        line: #{@line}
        col: #{@col}
        buf: #{@buf}
        hist:
          #{@hist.join("\n    ")}
      ED
    end

    private def add_to_history
      @hist << @buf.dup unless @buf.empty?
    end

    private def clear_line
      @buf.size.times { print '\b', ' ', '\b' }
      @buf.clear
    end

    private def handle_regular_char(c)
      print c
      @buf << c
      @col += 1
    end

    private def reset
      @buf.clear
      @col = 0
    end

    private def increment_line
      puts
      @line += 1
      @last_newline_col = @hist[@line].size
    end

    private def decrement_line
      print "\e[A"
      @line -= 1
      col = @last_newline_col.dup
      # col -= @prompt.size if @line.zero?
      col.times { print "\e[C" }
    end

    private def delete_char
      return if @buf.empty?
      c = @buf.pop
      if c == '\n'
        decrement_line
      else
        print '\b', ' ', '\b'
      end
    end

    private def handle_escape_char
      esc = ['\e'] of Char
      4.times do
        c = STDIN.raw(&.read_char).not_nil!
        esc << c
        # puts "\n -> #{c.inspect}, esc: #{esc.map(&.inspect).join}\n"
        case esc.join
        when "\e[1~" # home
          return clear_line
        when "\e[A" # up
          clear_line
          return if @hist.size.zero?
          @hist.last.each { |c| print c }
          @buf = @hist.last.dup
          @col = @buf.size
          return
        when "\e[B" # down
          puts "down"
          return
        when "\e[C" # right
          return
          # print esc.join
        when "\e[D" # left
          # print esc.join
          clear_line
          @buf.pop # todo: edit at curr pos
          @buf.each { |c| print c }
          return
        end
      end
    end
  end
end
