require 'ruby-mud/action/movement'

require_relative '../../test/test_world'

describe RubyMud::Action::Movement do
  before :each do
    TestWorld::reset
    @actor = RubyMud::World.instance.players["Actor"]
    @in_room = RubyMud::World.instance.players["InRoom"]
    @out_room = RubyMud::World.instance.players["OutOfRoom"]
  end
  describe "#move" do
    context "with a valid direction" do
      before :each do
        RubyMud::Action::Movement.move(RubyMud::World.instance, @actor, :north).should == true
      end
      it "should move the actor to the room in that direction" do
        RubyMud::World.instance.rooms[1].players[@actor.name].nil?.should == true
        RubyMud::World.instance.rooms[2].players[@actor.name].nil?.should == false
        @actor.in_room.should == 2
      end
      it "should send the room the actor was in a message that they left" do
        @in_room.messages[0].should == "Actor has left to the north."
      end
      it "should send the room the actor is moving into a message that they've arrived" do
        @out_room.messages[0].should == "Actor has arrived from the south."
      end
    end
    context "with an invalid direction" do
      before :each do
        RubyMud::Action::Movement.move(RubyMud::World.instance, @actor, :east).should == false
      end
      it "should not move the actor" do
        RubyMud::World.instance.rooms[1].players[@actor.name].nil?.should == false
        RubyMud::World.instance.rooms[2].players[@actor.name].nil?.should == true
        @actor.in_room.should == 1
      end
      it "should not send the room the actor was in a message" do
        @in_room.messages.empty?.should == true
      end
      it "should send the actor a message that the exit was invalid" do
        @actor.messages[0].should == "You cannot move in that direction."
      end
    end
  end
end