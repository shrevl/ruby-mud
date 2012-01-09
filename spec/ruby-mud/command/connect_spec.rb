require 'ruby-mud/command/connect'
require_relative '../../test/test_world'

describe RubyMud::Command::Connect do
  before :all do
    TestWorld.reset
    @actor = RubyMud::World.instance.players["Actor"]
    @in_room = RubyMud::World.instance.players["InRoom"]
    @out_room = RubyMud::World.instance.players["OutOfRoom"]
  end
  describe "#quit" do
    before :all do
      TestWorld.reset_players
      RubyMud::Command::Connect.quit @actor
    end
    it "should send a message to all players that the actor has left the game" do
      @in_room.messages[0].should == "[Actor has left the game]"
      @out_room.messages[0].should == "[Actor has left the game]"
    end
    it "should only send a room specific message to the players in the room with the actor" do
      @in_room.messages[1].should == "Actor has disappeared."
      @out_room.messages.length.should equal 1
    end
    it "should disconnect the actor from the game" do
      @actor.client.closed?.should == true
    end
    it "should remove the actor from the room" do
      RubyMud::World.instance.rooms[@actor.in_room].players[@actor.name].nil?.should == true
    end
    it "should remove the actor from the world" do
      RubyMud::World.instance.players[@actor.name].nil?.should == true
    end
    it "should not run on an actor who does not exist within the world" do
      @in_room.reset
      @out_room.reset
      run = RubyMud::Command::Connect.quit @actor
      run.should equal false
      @in_room.messages.length.should equal 0
      @out_room.messages.length.should equal 0
    end     
  end
end