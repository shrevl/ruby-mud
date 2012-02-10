require_relative '../message'

module RubyMud
  module Command
    module Chat
      def Chat.say(world, actor, words=[])
        text = words.join(" ").strip
        if(text.empty?)
          return false
        end
        world.rooms[actor.in_room].message RubyMud::Message::Key.new("chat.say", actor.name, text)
        true
      end
    end  
  end
end
