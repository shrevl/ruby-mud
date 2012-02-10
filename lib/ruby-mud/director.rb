require 'singleton'
require 'thread'

module RubyMud
  class Director
    include Singleton
    
    def initialize
      @queue = Queue.new
    end
    
    def queue_command(command)
      @queue.push command
    end
    
    def direct()
      @thread = Thread.start do
        loop do 
          command = @queue.pop
          command.call RubyMud::World.instance
        end
      end
    end
    
    def finish()
      Thread.kill @thread
    end
  end
end