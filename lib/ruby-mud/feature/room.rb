module RubyMud
  module Feature
    class Room
      attr_reader :id
      attr :players
      attr :exits
      
      def initialize(id, opts={})
        @id = id
        @players = {}
        @exits = opts[:exits] || {}
      end
    end
  end
end