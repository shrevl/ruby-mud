require 'singleton'
require 'thread'

module RubyMud
  class World
    attr :players
    attr :rooms
    attr :mobiles
    
    def initialize
      @players = {}
      @rooms = {}
    end

    def reset
      @players = {}
      @rooms = {}
    end

    def shutdown
      @players.each do |p_name, player|
        player.disconnect
      end
    end

    def add_player(player)
      #Add the player to the world
      @players[player.name] = player

      #Insert the player into their last known room
      @rooms[player.in_room].players[player.name] = player
    end

    def remove_player(player)
      #Remove the player from the room they are currently within
      @rooms[player.in_room].players.delete player.name

      #Remove the player from the world
      @players.delete player.name
    end

    def add_room(room)
      if @rooms[room.id].nil?
        @rooms[room.id] = room
        true
      else
        false
      end
    end
    
    def message(message, style_key=RubyMud::Style::Default_Key)
      @players.each do |p_name, player|
        player.message message, style_key
      end
    end
  end
end