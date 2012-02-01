require 'singleton'
require 'thread'

module RubyMud
  class Director
    include Singleton
    
    def initialize
      @queue = Queue.new
    end
    
    def queue_directive(directive)
      @queue.push directive
    end
    
    def direct()
      @thread = Thread.start do
        loop do 
          directive = @queue.pop
          directive.call RubyMud::World.instance
        end
      end
    end
    
    def finish()
      Thread.kill @thread
    end
  end
end