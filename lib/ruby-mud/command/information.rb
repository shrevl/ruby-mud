require_relative '../message'

module RubyMud
  module Command
    module Information
      def Information.look(actor, args=[])
        builder = RubyMud::Message::Builder.new
        room = RubyMud::World.instance.rooms[actor.in_room]
        builder << room.short_description
        room.players.each do |p_name, player|
          unless actor.equal? player
            builder << RubyMud::Message::Keyed.get(RubyMud::Message::Key.new("information.player.in_room", p_name))
          end
        end
        RubyMud::Message.send_to_actor actor, builder.build
      end
    end
  end
end