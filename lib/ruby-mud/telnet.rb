require 'term/ansicolor'
require 'net/telnet'

module RubyMud
  class Telnet < Net::Telnet
    def send_message(message, *styles)
      unless sock.closed?
        styles.each { |style| self.write style}
        self.write message + EOL
        unless styles.empty?
          self.write Term::ANSIColor.clear
        end
      end
    end
 
    def negotiateAboutWindowSize
      self.write IAC + DO + OPT_NAWS
      c = @sock.read(3)
=begin
      if c == IAC + WILL + OPT_NAWS
        subroutine = String.new
        begin
          c = @sock.read(1)
          Kernel::print c.unpack('H*')
          subroutine << c
        end while c != SE
        parse_naws_subroutine c
      end
=end
    end
  
    def preprocess(string)
      Kernel::puts string.unpack('H*')
      string.gsub(/#{IAC}#{SB}#{OPT_NAWS}..../xno) do |match|
        parse_naws_subroutine match
      end
      super(string)
    end
    
    def parse_naws_subroutine subroutine
        a = subroutine.unpack('C*')
        w1 = a[3]
        w2 = a[4]
        h1 = a[5]
        h2 = a[6]
        @height = (h1 * 256) + h2
        @width = (w1 * 256) + w2
        Kernel::puts "#{@width} x #{@height}"
    end

    def Telnet.newline
      EOL
    end
  end
end