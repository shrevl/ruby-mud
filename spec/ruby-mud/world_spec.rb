require 'ruby-mud/world'
require_relative '../test/test_world'

describe RubyMud::World do
  before :each do
    TestWorld.reset
    @actor = RubyMud::World.instance.players["Actor"]
  end
  describe "#shutdown" do
    it "should disconnect all players" do
      RubyMud::World.instance.shutdown
      RubyMud::World.instance.players.each do |p_name, player|
        player.client.sock.closed?.should equal true
      end
    end
  end
  describe "#add_player" do
    before :each do
      @new_player = RubyMud::World.instance.add_player RubyMud::Feature::Player.new(:name=>"NewPlayer")
      @existing_player = RubyMud::World.instance.add_player RubyMud::Feature::Player.new(:name=>"ExistingPlayer", :in_room=>2)
    end
    it "should add the player to the world" do
      RubyMud::World.instance.players[@new_player.name].nil?.should == false
      RubyMud::World.instance.players[@existing_player.name].nil?.should == false
    end
    it "should add a new player to the starting room" do
      RubyMud::World.instance.rooms[1].players[@new_player.name].nil?.should == false
    end
    it "should add existing players to their last known room" do
      RubyMud::World.instance.rooms[@existing_player.in_room].players[@existing_player.name].nil?.should == false
    end
  end
  describe "#remove_player" do
    before :each do
      RubyMud::World.instance.remove_player @actor
    end
    it "should remove the player from the world" do
      RubyMud::World.instance.players[@actor.name].nil?.should == true
    end
    it "should remove the player from the room they were in" do
      RubyMud::World.instance.rooms[@actor.in_room].players[@actor.name].nil?.should == true
    end
  end
  describe "#add_room" do
    context "with a room with a globally unique id" do
      before :each do
        @added = RubyMud::World.instance.add_room RubyMud::Feature::Room.new 123
      end
      it "should add the room to the world" do
        @added.should == true
        RubyMud::World.instance.rooms[123].nil?.should == false
      end
    end
    context "with a room with an existing id" do
      before :each do
        @added = RubyMud::World.instance.add_room RubyMud::Feature::Room.new 1
      end
      it "should not add the room to the world" do
        @added.should == false
      end
    end
  end
end