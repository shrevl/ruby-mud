require 'term/ansicolor'
require 'net/telnet'

module RubyMud
  class Telnet < Net::Telnet
    def send_message(message, styles=[])
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
      #the immediate response will either be IAC WILL OPT_NAWS and a subnegotiation or IAC WONT OPT_NAWS
      #either way, we do not care about this response, and do not want the preprocessing code to pick it
      #up, as it will respond and enforce a IAC DONT OPT_NAWS
      @sock.read(3)
    end
  
    def preprocess(string)
      #the base telnet code separates IAC SE from its actual subnegotiation parsing, leaving it laying
      #about for when use input makes its way in. we can simply clear it out with no consequence
      string.gsub!(/#{IAC}#{SE}/, '')
      #the client has sent information about its terminal window size, we should update the known sizes
      string.gsub(/#{IAC}#{SB}#{OPT_NAWS}..../xno) do |match|
        parse_naws_subroutine match
      end
      #the rest of the preprocessing will not care about the subnegotiation
      string.gsub!(/#{IAC}#{SB}#{OPT_NAWS}..../xno, '')
      super(string)
    end
    
    def parse_naws_subroutine subroutine
      #subroutine should be in the format:
      #IAC SB OPT_NAWS W1 W2 H1 H2
      #where W1 and H1 are multipliers of 256
      a = subroutine.unpack('C*')
      w1 = a[3]
      w2 = a[4]
      h1 = a[5]
      h2 = a[6]
      @height = (h1 * 256) + h2
      @width = (w1 * 256) + w2
    end

    def Telnet.newline
      EOL
    end
  end
end