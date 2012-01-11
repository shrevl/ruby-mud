require 'term/ansicolor'

module RubyMud
  module Telnet
    NEWLINE = [13, 10].pack("c*")
    def Telnet.send(client, message, *styles)
      unless client.sock.closed?
        styles.each { |style| client.write style}
        client.write message + NEWLINE
        unless styles.empty?
          client.write Term::ANSIColor.clear
        end
      end
    end
    
    def Telnet.newline
      NEWLINE
    end
  end
end