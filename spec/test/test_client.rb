require 'ruby-mud/telnet'
require 'term/ansicolor'

require_relative 'test_socket'

class TestClient < RubyMud::Telnet
  attr :sock, true
  attr :messages, true
  
  def initialize
    @sock = TestSocket.new
    @messages = []
  end
  
  def write(message)
    #remove ansi coloring so we can ease message verification
    message = Term::ANSIColor.uncolored message
    #remove the \r\n so that we can simply compare messages for testing
    lines = message.split RubyMud::Telnet.newline
    @messages += lines
  end
end