module RubyMud
  module Message
    def Message.send_to_actor(actor, message)
      actor.puts message
    end
    
    def Message.send_to_room(room_id, message)
      RubyMud::World.instance.rooms[room_id].players.each do |p_name, player|
        Message.send_to_actor player, message
      end
    end
    
    def Message.send_global(message)
      RubyMud::World.instance.players.each do |p_name, player|
        Message.send_to_actor player, message
      end
    end
  end
end