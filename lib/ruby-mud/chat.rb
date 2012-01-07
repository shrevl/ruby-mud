module Chat
  def Chat.say(actor, words=[])
    text = words.join(" ").strip
    if(text.empty?)
      return false
    end
    puts "[Say] #{actor.name}: " + text
    true
  end
end
