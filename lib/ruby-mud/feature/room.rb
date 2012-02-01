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
      
      def message(message, style_key=RubyMud::Style::Default_Key)
        @players.each do |p_name, player|
          player.message message, style_key
        end
      end
    end
  end
end