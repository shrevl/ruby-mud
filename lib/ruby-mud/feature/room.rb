module RubyMud
  module Feature
    class Room
      attr :players
      attr_reader :id
      def initialize(id)
        @players = {}
        @id = id
      end
    end
  end
end