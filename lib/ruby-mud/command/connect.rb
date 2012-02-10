require_relative '../message'
require_relative '../world'

module RubyMud
  module Command
    module Connect
      def Connect.quit(world, player, args=[])
        removed_player = world.remove_player player
        unless removed_player.nil?
          player.disconnect
          world.message RubyMud::Message::Key.new("player.global.quit", player.name)
          world.rooms[player.in_room].message RubyMud::Message::Key.new("player.room.quit", player.name)
          true
        else
          false
        end
      end
    end
  end
end
