require_relative 'actor'

module RubyMud
  module Feature
    class Player < Actor
      attr :client, true
      
      def initialize(opts={})
        super(opts)
        @client = opts[:client]
      end
      
      def puts(message)
        unless @client.closed?
          @client.puts message
        end
      end
      
      def disconnect
        unless @client.closed?
          @client.close
        end
      end
    end  
  end
end