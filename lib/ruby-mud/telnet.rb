module RubyMud
  module Telnet
    NEWLINE = [13, 10].pack("c*")
    def Telnet.send(client, message)
      unless client.sock.closed?
        client.write message + NEWLINE
      end
    end
  end
end