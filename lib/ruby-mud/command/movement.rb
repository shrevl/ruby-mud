require_relative '../message'

module RubyMud
  module Command
    module Movement
      def Movement.move(actor, direction, args=[])
        exit = RubyMud::World.instance.rooms[actor.in_room].exits[direction]
        unless exit.nil?
          from_room_id = actor.in_room
          RubyMud::World.instance.rooms[from_room_id].players.delete actor.name
          RubyMud::Message.send_to_room from_room_id, "movement.leave", actor.name, direction.to_s
          RubyMud::Message.send_to_room exit.room_id, "movement.arrive", actor.name, RubyMud::Command::Movement::Direction.reverse(direction).to_s
          RubyMud::World.instance.rooms[exit.room_id].players[actor.name] = actor
          actor.in_room = exit.room_id
          true
        else
          #invalid direction, issue message to actor
          RubyMud::Message.send_to_actor actor, "movement.invalid"
          false
        end
      end
      
      module Direction
        @reverse_directions = {
                                :north => :south,
                                :south => :north,
                                :east => :west,
                                :west => :east
                              }
        def Direction.reverse(direction)
          @reverse_directions[direction]
        end
      end
    end
  end
end