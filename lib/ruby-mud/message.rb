require 'yaml'

module RubyMud
  module Message
    @messages = YAML.load_file(File.expand_path "../../../config/messages.yaml", __FILE__)
    
    def Message.send_to_client client, message_key, *args
      RubyMud::Telnet.send client, Message.get(message_key, *args)
    end
    
    def Message.send_to_actor(actor, message_key, *args)
      Message.send_to_client actor.client, message_key, *args
    end
    
    def Message.send_to_room(room_id, message_key, *args)
      RubyMud::World.instance.rooms[room_id].players.each do |p_name, player|
        Message.send_to_actor player, message_key, *args
      end
    end
    
    def Message.send_global(message_key, *args)
      RubyMud::World.instance.players.each do |p_name, player|
        Message.send_to_actor player, message_key, *args
      end
    end
    
    def Message.get(message_key, *args)
      message = @messages
      message_key.split('.').each do |key|
        unless message.nil?
          message = message[key]
        end
      end
      assign_arguments message, args
    end
    
    private
    def Message.assign_arguments(message, args)
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