require 'ruby-mud/command/information'
require_relative '../../test/test_world'

describe RubyMud::Command::Information do
  before :all do
    TestWorld::reset
    @actor = RubyMud::World.instance.players["Actor"]
    @in_room = RubyMud::World.instance.players["InRoom"]
    @room_short_description = RubyMud::World.instance.rooms[@actor.in_room].short_description
  end
  describe "#look" do
    context "with no arguments" do
      before :each do
        TestWorld::reset_players
        RubyMud::Command::Information.look @actor
      end
      it "should send the short description to the actor" do
        @actor.messages[0].should == @room_short_description
      end
      it "should send a list of available directions to move" do
        @actor.messages[1].should == "[ North ]"
      end
      it "should send a list of other players in the room" do
        @actor.messages[2].should == RubyMud::Message::Keyed.get(RubyMud::Message::Key.new("information.player.in_room", @in_room.name))
      end
    end
  end
end