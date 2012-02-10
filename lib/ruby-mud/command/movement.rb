require_relative '../action/movement'

module RubyMud
  module Command
    module Movement
      def Movement.move(world, actor, direction, args=[])
        RubyMud::Action::Movement.move(world, actor, direction)
        true
      end
    end
  end
end