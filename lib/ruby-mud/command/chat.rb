require_relative '../message'

module RubyMud
  module Command
    module Chat
      def Chat.say(actor, words=[])
        text = words.join(" ").strip
        if(text.empty?)
          return false
        end
        RubyMud::Message::Keyed.send_to_room actor.in_room, RubyMud::Message::Key.new("chat.say", actor.name, text)
        true
      end
    end  
  end
end
