require_relative '../message'
require_relative 'information'

module RubyMud
  module Command
    module Movement
      def Movement.move(actor, direction, args=[])
        exit = RubyMud::World.instance.rooms[actor.in_room].exits[direction]
        unless exit.nil?
          from_room_id = actor.in_room
          RubyMud::World.instance.rooms[from_room_id].players.delete actor.name
          RubyMud::Message::Keyed.send_to_room from_room_id, RubyMud::Message::Key.new("movement.leave", actor.name, direction.to_s)
          RubyMud::Message::Keyed.send_to_room exit.room_id, RubyMud::Message::Key.new("movement.arrive", actor.name, RubyMud::Command::Movement::Direction.reverse(direction).to_s)
          RubyMud::World.instance.rooms[exit.room_id].players[actor.name] = actor
          actor.in_room = exit.room_id
          if actor.auto_look?
            RubyMud::Command::Information.look(actor)
          end
          true
        else
          #invalid direction, issue message to actor
          RubyMud::Message::Keyed.send_to_actor actor, RubyMud::Message::Key.new("movement.invalid")
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
                              
        @direction_short = {
                             :north => "N",
                             :south => "S",
                             :east => "E",
                             :west => "W"
                           }
                           
        def Direction.reverse(direction)
          @reverse_directions[direction]
        end
        
        def Direction.short(direction)
          @direction_short[direction]
        end
        
        def Direction.long(direction)
          direction.to_s.capitalize
        end
      end
    end
  end
end