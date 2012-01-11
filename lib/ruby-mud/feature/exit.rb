module RubyMud
  module Feature
    class Exit
      attr :room_id
      
      def initialize(room_id, opts={})
        @room_id = room_id
      end
    end
  end
end