module RubyMud
  module Feature
    module Direction
      @reverse_directions = {
                              :north => :south,
                              :south => :north,
                              :east => :west,
                              :west => :east
                            }
                            
      @direction_short = {
                           :north => "N",
                           :south => "S",
                           :east => "E",
                           :west => "W"
                         }
                         
      def Direction.reverse(direction)
        @reverse_directions[direction]
      end
      
      def Direction.short(direction)
        @direction_short[direction]
      end
      
      def Direction.long(direction)
        direction.to_s.capitalize
      end
    end
  end
end