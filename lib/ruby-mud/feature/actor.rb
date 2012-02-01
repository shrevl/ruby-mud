require_relative '../config'

module RubyMud
  module Feature
    class Actor
      attr :name, true
      attr :id, true
      attr :in_room, true
      
      def initialize(opts={})
        @name = opts[:name]
        @id = opts[:id]
        @in_room = opts[:in_room] || RubyMud::Config::World_Starting_Room
      end
      
      def message(message, style_key=RubyMud::Style::Default_Key)
        Message.send_to_actor self, message, style_key
      end
    end  
  end
end