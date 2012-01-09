require 'ruby-mud/world'
require 'ruby-mud/feature/room'
require 'ruby-mud/feature/player'

module TestWorld
  class TestPlayer < RubyMud::Feature::Player
    attr :messages, true
    
    def initialize(opts=[])
      super(opts)
      @messages = []
    end
    
    def puts(message)
      @messages.push message
    end
    
    def reset
      @messages = []
      @client = TestSocket.new
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
    RubyMud::World.instance.add_room(RubyMud::Feature::Room.new 1)
    RubyMud::World.instance.add_room(RubyMud::Feature::Room.new 2)
    
    RubyMud::World.instance.add_player TestPlayer.new(:name => "Actor", :client => TestSocket.new)
    RubyMud::World.instance.add_player TestPlayer.new(:name => "InRoom", :client => TestSocket.new)
    RubyMud::World.instance.add_player TestPlayer.new(:name => "OutOfRoom", :in_room => 2, :client => TestSocket.new)
  end
  
  def TestWorld.reset_players
    RubyMud::World.instance.players.each do |p_name, player|
      player.reset
    end
  end
end