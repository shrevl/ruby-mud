require_relative '../message'
require_relative '../style'
require_relative 'movement'


module RubyMud
  module Command
    module Information
      def Information.look(actor, args=[])
        builder = RubyMud::Message::Builder.new
        room = RubyMud::World.instance.rooms[actor.in_room]
        builder << RubyMud::Style.get("room.short_description") << room.short_description << RubyMud::Style::Clear
        builder << exits_in_room(room)
        builder << other_players_in_room(room, actor)
        RubyMud::Message.send_to_actor actor, builder.build
      end
      
      private
      def Information.exits_in_room(room)
        builder = RubyMud::Message::Builder.new
        exits = "[ "
        unless room.exits.empty?
          directions = room.exits.keys
          directions.each do |direction|
            exits += RubyMud::Command::Movement::Direction.long direction
            unless direction.eql? directions.last
              exits += ", "
            end
          end
        else
          exits += RubyMud::Message.get("room.no_exit")
        end
        exits += " ]"
        builder << RubyMud::Style.get("room.exits") << exits << RubyMud::Style::Clear
      end
      
      def Information.other_players_in_room(room, actor)
        builder = RubyMud::Message::Builder.new
        builder << RubyMud::Style.get("room.players")
        room.players.each do |p_name, player|
          unless actor.equal? player
            builder << RubyMud::Message::Keyed.get(RubyMud::Message::Key.new("information.player.in_room", p_name))
          end
        end
        builder << RubyMud::Style::Clear
      end
    end
  end
end