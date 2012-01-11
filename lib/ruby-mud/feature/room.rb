module RubyMud
  module Feature
    class Room
      attr :id
      attr :short_description, true
      attr :players
      attr :exits
      
      def initialize(id, opts={})
        @id = id
        @short_description = opts[:short_description]
        @players = {}
        @exits = opts[:exits] || {}
      end
    end
  end
end