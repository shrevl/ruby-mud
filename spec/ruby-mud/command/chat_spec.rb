require 'ruby-mud/command/chat'
require_relative '../../test/test_world'

describe RubyMud::Command::Chat do
  before :all do
    TestWorld.reset
    @world = RubyMud::World.instance
    @actor = @world.players["Actor"]
    @in_room = @world.players["InRoom"]
    @out_room = @world.players["OutOfRoom"]
  end
  describe "#say" do
    context "with invalid input" do
      before :each do
        TestWorld.reset_players
      end
      it "should not run without words" do
        RubyMud::Command::Chat.say(@world, @actor).should equal false
      end
      it "should not run with empty words" do
        RubyMud::Command::Chat.say(@world, @actor, []).should equal false
      end
      it "should not run with words that equate to nothing" do
        RubyMud::Command::Chat.say(@world, @actor, [""]).should equal false
        RubyMud::Command::Chat.say(@world, @actor, [""," "]).should equal false
      end
      it "should not send a message to any actors when unsuccessful" do
        RubyMud::Command::Chat.say(@world, @actor)
        RubyMud::Command::Chat.say(@world, @actor, [])
        RubyMud::Command::Chat.say(@world, @actor, [""])
        RubyMud::Command::Chat.say(@world, @actor, [""," "])
        @world.players.each do |p_name, player|
          player.messages.empty?.should equal true
        end
      end
    end
    context "with a single word" do
      before :all do
        TestWorld.reset_players
        @run = RubyMud::Command::Chat.say(@world, @actor, ["word"])
      end
      it "should run" do
        @run.should equal true
      end
      it "should send a message to the actor" do
        @actor.messages[0].should == "[Say] Actor: word"
      end
      it "should send a message to other players in the same room" do
        @in_room.messages[0].should == "[Say] Actor: word"
      end
      it "should not send a message to players outside the room" do
        @out_room.messages.empty?.should equal true
      end
    end
    context "with multiple words" do
      before :all do
        TestWorld.reset_players
        @run = RubyMud::Command::Chat.say(@world, @actor, ["multiple", "words should be", "valid"])
      end
      it "should run" do
        @run.should equal true
      end
      it "should send a message with multiple words concatonated by a ' ' separator" do
        @actor.messages[0].should == "[Say] Actor: multiple words should be valid"
      end
      it "should send a message with multiple words concatonated by a ' ' separator to other players in the same room" do
        @in_room.messages[0].should == "[Say] Actor: multiple words should be valid"
      end
      it "should not send a message to players outside the room" do
        @out_room.messages.empty?.should equal true
      end
    end
  end
end
