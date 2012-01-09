require_relative '../message'
require_relative '../world'

module RubyMud
  module Command
    module Connect
      def Connect.quit(player, args=[])
        removed_player = RubyMud::World.instance.remove_player player
        unless removed_player.nil?
          player.disconnect
          RubyMud::Message.send_global "[#{player.name} has left the game]"
          RubyMud::Message.send_to_room player.in_room, "#{player.name} has disappeared."
          true
        else
          false
        end
      end
    end
  end
end
