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
    end  
  end
end