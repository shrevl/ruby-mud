require_relative 'actor'
require_relative '../telnet'

module RubyMud
  module Feature
    class Player < Actor
      attr :client, true
      attr :auto_look
      
      def initialize(opts={})
        super(opts)
        @client = opts[:client]
        @auto_look = opts[:auto_look] || true
      end
      
      def disconnect
        unless @client.sock.closed?
          @client.sock.close
        end
      end
      
      def auto_look?
        auto_look
      end
    end  
  end
end