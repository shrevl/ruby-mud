require 'ruby-mud/chat'
require 'ruby-mud/player'

describe Chat do
  player = Player.new
  player.name = "Player"
  describe "#say" do
    it "should not run without words" do
      Chat.say(player).should == false
    end
    it "should not run with empty words" do
      Chat.say(player, []).should == false
    end
    it "should not run with words that equate to nothing" do
      Chat.say(player, [""]).should == false
      Chat.say(player, [""," "]).should == false
    end
    it "should run with a single word" do
      Chat.say(player, ["word"]).should == true
    end
    it "should run with multiple words" do
      Chat.say(player, ["multiple", "words should be", "valid"]).should == true  
    end
  end
end
