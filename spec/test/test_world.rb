require 'ruby-mud/feature/exit'
require 'ruby-mud/feature/room'
require 'ruby-mud/world'

require_relative 'test_client'
require_relative 'test_player'

class TestWorld < RubyMud::World
  def intialize
    super
    add_room(RubyMud::Feature::Room.new(1, {
                                             :short_description => "Room 1",
                                             :exits => {:north => RubyMud::Feature::Exit.new(2)}
                                           }))
    add_room(RubyMud::Feature::Room.new(2, {
                                             :short_description => "Room 2",
                                             :exits => {:south => RubyMud::Feature::Exit.new(1)}
                                           }))
    
    add_player TestPlayer.new(:name => "Actor", :client => TestClient.new)
    add_player TestPlayer.new(:name => "InRoom", :client => TestClient.new)
    add_player TestPlayer.new(:name => "OutOfRoom", :in_room => 2, :client => TestClient.new)
  end
  
  def reset_players
    @players.each do |p_name, player|
      player.reset
    end
  end
end