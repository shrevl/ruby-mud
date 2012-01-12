require_relative '../message'
require_relative 'movement'
require 'term/ansicolor'

module RubyMud
  module Command
    module Information
      def Information.look(actor, args=[])
        builder = RubyMud::Message::Builder.new
        room = RubyMud::World.instance.rooms[actor.in_room]
        builder << Term::ANSIColor.bold << Term::ANSIColor.blue << room.short_description << Term::ANSIColor.dark
        unless room.exits.empty?
          exits = "[ "
          directions = room.exits.keys
          directions.each do |direction|
            exits += RubyMud::Command::Movement::Direction.long direction
            unless direction.eql? directions.last
              exits += ", "
            end
          end
          exits += " ]"
          builder << Term::ANSIColor.yellow << exits
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