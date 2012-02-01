require 'yaml'
require_relative 'hash'
require_relative 'style'

module RubyMud
  module Message
    def Message.send_to_client(client, message, style_key=RubyMud::Style::Default_Key)
      client.send_message message, RubyMud::Style.get(style_key)
    end
    
    def Message.send_to_actor(actor, message, style_key=RubyMud::Style::Default_Key)
      if message.is_a? RubyMud::Message::Key
        message = Keyed.get(message)
      end
      Message.send_to_client(actor.client, message, style_key)
    end
    
    def Message.send_to_room(room_id, message, style_key=RubyMud::Style::Default_Key)
      RubyMud::World.instance.rooms[room_id].players.each do |p_name, player|
        Message.send_to_actor player, message, style_key
      end
    end
    
    def Message.send_global(message, style_key=RubyMud::Style::Default_Key)
      RubyMud::World.instance.players.each do |p_name, player|
        Message.send_to_actor player, message, style_key
      end
    end
    
    class Builder
      def initialize
        @messages = []
      end
      
      def << m
        if(m.is_a? Array or m.is_a? Builder)
          m.each {|piece| self << piece}
        else
          unless is_escape_sequence?(m)
            @last_visible_message = @messages.length
          end
          @messages << m
        end
        self
      end
      
      def each
        @messages.each {|m| yield m}
      end
      
      def build
        message = String.new
        @messages.each_with_index do |m, i|
          message +=  m
          unless is_escape_sequence?(m) or i == @last_visible_message
            message += RubyMud::Telnet.newline
          end
        end
        message
      end
      
      private
      def is_escape_sequence?(message)
        message.start_with? 27.chr
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
    
      def Keyed.send_to_client(client, message_key)
        Message.send_to_client client, Keyed.get(message_key), message_key.key
      end
      
      def Keyed.send_to_actor(actor, message_key)
        Message.send_to_actor actor, Keyed.get(message_key), message_key.key
      end
      
      def Keyed.send_to_room(room_id, message_key)
        Message.send_to_room room_id, Keyed.get(message_key), message_key.key
      end
      
      def Keyed.send_global(message_key)
        Message.send_global Keyed.get(message_key), message_key.key
      end
      
      def Keyed.get(message_key)
        message = @messages.get_multikey message_key.key
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