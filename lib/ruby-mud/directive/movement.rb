require_relative '../action/movement'
require_relative '../feature/direction'

module RubyMud
  module Directive
    module Movement
      def Movement.move(actor, direction)
        lambda do |world|
          RubyMud::Action::Movement.move(world, actor, direction)
        end
      end
    end
  end  
end