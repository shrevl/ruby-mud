module RubyMud
  module Feature
    class Actor
      attr :name, true
      attr :id, true
      attr :in_room, true
      
      def initialize(opts={})
        @name = opts[:name]
        @id = opts[:id]
        @in_room = opts[:in_room] || 1
      end
    end  
  end
end