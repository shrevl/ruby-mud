require 'ruby-mud/message'
require_relative '../test/test_world'

describe RubyMud::Message do
  before :all do
    TestWorld.reset
    @actor = RubyMud::World.instance.players["Actor"]
    @in_room = RubyMud::World.instance.players["InRoom"]
    @out_room = RubyMud::World.instance.players["OutOfRoom"]
  end
  describe "#send_to_actor" do
    before :all do
      TestWorld.reset_players
      RubyMud::Message.send_to_actor @actor, "send to actor"
    end
    it "should send the message to the actor" do
      @actor.messages[0].should == "send to actor"
    end
    it "should not send a message to any other players" do
      @in_room.messages.length.should equal 0
      @out_room.messages.length.should equal 0
    end
  end
  describe "#send_to_room" do
    before :all do
      TestWorld.reset_players
      RubyMud::Message.send_to_room @actor.in_room, "send to room"
    end
    it "should send the message to all players in the room" do
      @actor.messages[0].should == "send to room"
      @in_room.messages[0].should == "send to room"
    end
    it "should not send the message to players outside the room" do
      @out_room.messages.length.should equal 0
    end
  end
  describe "#send_global" do
    before :all do
      TestWorld.reset_players
      RubyMud::Message.send_global "global message"
    end
    it "should send the messages to all players" do
      RubyMud::World.instance.players.each do |p_name, player|
        player.messages[0].should == "global message"
      end
    end
  end
end
