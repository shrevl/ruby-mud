require_relative 'actor'
require_relative '../telnet'

module RubyMud
  module Feature
    class Player < Actor
      attr :client, true
      
      def initialize(opts={})
        super(opts)
        @client = opts[:client]
      end
      
      def disconnect
        unless @client.sock.closed?
          @client.sock.close
        end
      end
    end  
  end
end