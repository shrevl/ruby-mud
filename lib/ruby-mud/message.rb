require 'yaml'

module RubyMud
  module Message
    def Message.send_to_client(client, message, *styles)
      RubyMud::Telnet.send client, message, *styles
    end
    
    def Message.send_to_actor(actor, message, *styles)
      Message.send_to_client(actor.client, message, *styles)
    end
    
    def Message.send_to_room(room_id, message, *styles)
      RubyMud::World.instance.rooms[room_id].players.each do |p_name, player|
        Message.send_to_actor player, message, *styles
      end
    end
    
    def Message.send_global(message, *styles)
      RubyMud::World.instance.players.each do |p_name, player|
        Message.send_to_actor player, message, *styles
      end
    end
    
    class Builder
      def initialize
        @messages = []
      end
      
      def << m
        @messages << m
        self
      end
      
      def build
        @messages.join RubyMud::Telnet.newline
      end
    end
    
    class Key
      attr :key
      attr :args
      
      def initialize(message_key, *args)
        @key = message_key
        @args = args  
      end
    end
    
    module Keyed
      @messages = YAML.load_file(File.expand_path "../../../config/messages.yaml", __FILE__)
    
      def Keyed.send_to_client(client, message_key, *styles)
        Message.send_to_client client, Keyed.get(message_key), *styles
      end
      
      def Keyed.send_to_actor(actor, message_key, *styles)
        Message.send_to_actor actor, Keyed.get(message_key), *styles
      end
      
      def Keyed.send_to_room(room_id, message_key, *styles)
        Message.send_to_room room_id, Keyed.get(message_key), *styles
      end
      
      def Keyed.send_global(message_key, *styles)
        Message.send_global Keyed.get(message_key), *styles
      end
      
      def Keyed.get(message_key)
        message = @messages
        message_key.key.split('.').each do |key|
          unless message.nil?
            message = message[key]
          end
        end
        assign_arguments message, message_key.args
      end
      
      private
      def Keyed.assign_arguments(message, args)
        unless message.nil?
          message = message.dup
          num = 1
          args.each do |arg|
            message.gsub! "{#{num}}", arg
            num += 1
          end
        end
        message
      end
    end
  end
end