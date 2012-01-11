require_relative '../message'
require_relative '../world'

module RubyMud
  module Command
    module Connect
      def Connect.quit(player, args=[])
        removed_player = RubyMud::World.instance.remove_player player
        unless removed_player.nil?
          player.disconnect
          RubyMud::Message::Keyed.send_global RubyMud::Message::Key.new("player.global.quit", player.name)
          RubyMud::Message::Keyed.send_to_room player.in_room, RubyMud::Message::Key.new("player.room.quit", player.name)
          true
        else
          false
        end
      end
    end
  end
end
