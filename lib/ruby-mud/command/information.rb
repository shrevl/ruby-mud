require_relative '../message'
require_relative 'movement'
require 'term/ansicolor'

module RubyMud
  module Command
    module Information
      def Information.look(actor, args=[])
        builder = RubyMud::Message::Builder.new
        room = RubyMud::World.instance.rooms[actor.in_room]
        builder << Term::ANSIColor.blue << room.short_description 
        unless room.exits.empty?
          exits = "[ "
          room.exits.each_key do |direction|
            RubyMud::Command::Movement::Direction.short direction
          end
          exits += " ]"
        end
        builder << Term::ANSIColor.green
        room.players.each do |p_name, player|
          unless actor.equal? player
            builder << RubyMud::Message::Keyed.get(RubyMud::Message::Key.new("information.player.in_room", p_name))
          end
        end
        builder << Term::ANSIColor.clear
        RubyMud::Message.send_to_actor actor, builder.build
      end
    end
  end
end