require_relative '../message'
require_relative '../command/information'

module RubyMud
  module Action
    module Movement
      def Movement.move(world, actor, direction)
        from_room_id = actor.in_room
        exit = world.rooms[from_room_id].exits[direction]
        unless exit.nil?
          world.rooms[from_room_id].players.delete actor.name
          world.rooms[from_room_id].message RubyMud::Message::Key.new("movement.leave", actor.name, direction.to_s)
          world.rooms[exit.room_id].message RubyMud::Message::Key.new("movement.arrive", actor.name, RubyMud::Feature::Direction.reverse(direction).to_s)
          world.rooms[exit.room_id].players[actor.name] = actor
          actor.in_room = exit.room_id
          if actor.auto_look?
            RubyMud::Command::Information.look(actor)
          end
            true
        else
          #invalid direction, issue message to actor
          actor.message RubyMud::Message::Key.new("movement.invalid")
          false
        end
      end
    end
  end
end