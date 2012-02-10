require 'ruby-mud/command/connect'
require_relative '../../test/test_world'

describe RubyMud::Command::Connect do
  before :all do
    @world = TestWorld.new
    @actor = @world.players["Actor"]
    @in_room = @world.players["InRoom"]
    @out_room = @world.players["OutOfRoom"]
  end
  describe "#quit" do
    before :all do
      @world.reset_players
      RubyMud::Command::Connect.quit @world, @actor
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
      @actor.client.sock.closed?.should == true
    end
    it "should remove the actor from the room" do
      @world.rooms[@actor.in_room].players[@actor.name].nil?.should == true
    end
    it "should remove the actor from the world" do
      @world.players[@actor.name].nil?.should == true
    end
    it "should not run on an actor who does not exist within the world" do
      @in_room.reset
      @out_room.reset
      run = RubyMud::Command::Connect.quit @world, @actor
      run.should equal false
      @in_room.messages.length.should equal 0
      @out_room.messages.length.should equal 0
    end     
  end
end