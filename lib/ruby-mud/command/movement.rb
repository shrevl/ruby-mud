require_relative '../director'
require_relative '../directive/movement'

module RubyMud
  module Command
    module Movement
      def Movement.move(actor, direction, args=[])
        RubyMud::Director.instance.queue_directive RubyMud::Directive::Movement.move(actor, direction)
        true
      end
    end
  end
end