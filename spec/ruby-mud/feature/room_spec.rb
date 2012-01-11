require 'ruby-mud/feature/exit'
require 'ruby-mud/feature/room'

describe RubyMud::Feature::Room do
  before :all do
    @room_id = 1
  end
  shared_examples_for "init" do
    it "should have its room id set" do
        @room.id.should == @room_id
      end
      it "should have no players within it" do
        @room.players.empty?.should == true
      end
  end
  context "after initialization" do
    context "without options specified" do
      before :all do
        @room = RubyMud::Feature::Room.new @room_id
      end
      it_behaves_like "init"
      it "should have no exits" do
        @room.exits.empty?.should == true
      end
      it "should have no short description" do
        @room.short_description.nil?.should == true
      end
    end
    context "with exits specified" do
      before :all do
        @exits = { :north => RubyMud::Feature::Exit.new(2), :east => RubyMud::Feature::Exit.new(3) }
        @room = RubyMud::Feature::Room.new @room_id, {:exits => @exits}
      end
      it_behaves_like "init"
      it "should have its exits set" do
        @room.exits.should equal @exits
      end
    end
    context "with short description specified" do
      before :all do
        @room = RubyMud::Feature::Room.new @room_id, {:short_description => "A short description"}
      end
      it_behaves_like "init"
      it "should have its short description set" do
        @room.short_description.should == "A short description"
      end
    end
  end
end
