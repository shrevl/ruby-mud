module RubyMud
  module Telnet
    NEWLINE = [10, 13].pack("c*")
    def Telnet.send(client, message)
      client.write message + NEWLINE
    end
  end
end