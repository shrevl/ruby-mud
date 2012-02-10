require_relative '../action/information'

module RubyMud
  module Command
    module Information
      def Information.look(world, actor, args=[])
        RubyMud::Action::Information.look(world, actor)
      end
    end
  end
end