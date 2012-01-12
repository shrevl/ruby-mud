require 'ruby-mud/feature/exit'
require 'ruby-mud/feature/room'
require 'ruby-mud/feature/player'
require 'ruby-mud/telnet'
require 'ruby-mud/world'

require 'term/ansicolor'

module TestWorld
  class TestPlayer < RubyMud::Feature::Player
    
    def messages
      @client.messages
    end
    
    def reset
      @client = TestClient.new
    end
  end
  
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
  
  class TestSocket
    @closed = false
    
    def closed?
      @closed
    end
    
    def close
      @closed = true
    end
  end
  
  def TestWorld.reset
    RubyMud::World.instance.reset
    RubyMud::World.instance.add_room(RubyMud::Feature::Room.new(1, {
                                                                     :short_description => "Room 1",
                                                                     :exits => {:north => RubyMud::Feature::Exit.new(2)}
                                                                   }))
    RubyMud::World.instance.add_room(RubyMud::Feature::Room.new(2, {
                                                                     :short_description => "Room 2",
                                                                     :exits => {:south => RubyMud::Feature::Exit.new(1)}
                                                                   }))
    
    RubyMud::World.instance.add_player TestPlayer.new(:name => "Actor", :client => TestClient.new)
    RubyMud::World.instance.add_player TestPlayer.new(:name => "InRoom", :client => TestClient.new)
    RubyMud::World.instance.add_player TestPlayer.new(:name => "OutOfRoom", :in_room => 2, :client => TestClient.new)
  end
  
  def TestWorld.reset_players
    RubyMud::World.instance.players.each do |p_name, player|
      player.reset
    end
  end
end