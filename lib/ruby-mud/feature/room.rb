module RubyMud
  module Feature
    class Room
      attr :id
      attr :short_description, true
      attr :exits
      
      attr :players
      attr :mobiles
      
      def initialize(id, opts={})
        @id = id
        @short_description = opts[:short_description]
        @exits = opts[:exits] || {}
        
        @players = {}
        @mobiles = {}
      end
    end
  end
end