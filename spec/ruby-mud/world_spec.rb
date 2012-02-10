require 'ruby-mud/world'
require_relative '../test/test_world'

describe RubyMud::World do
  before :each do
    @world = TestWorld.new
    @actor = @world.players["Actor"]
  end
  describe "#shutdown" do
    it "should disconnect all players" do
      @world.shutdown
      @world.players.each do |p_name, player|
        player.client.sock.closed?.should equal true
      end
    end
  end
  describe "#add_player" do
    before :each do
      @new_player = @world.add_player RubyMud::Feature::Player.new(:name=>"NewPlayer")
      @existing_player = @world.add_player RubyMud::Feature::Player.new(:name=>"ExistingPlayer", :in_room=>2)
    end
    it "should add the player to the world" do
      @world.players[@new_player.name].nil?.should == false
      @world.players[@existing_player.name].nil?.should == false
    end
    it "should add a new player to the starting room" do
      @world.rooms[1].players[@new_player.name].nil?.should == false
    end
    it "should add existing players to their last known room" do
      @world.rooms[@existing_player.in_room].players[@existing_player.name].nil?.should == false
    end
  end
  describe "#remove_player" do
    before :each do
      @world.remove_player @actor
    end
    it "should remove the player from the world" do
      @world.players[@actor.name].nil?.should == true
    end
    it "should remove the player from the room they were in" do
      @world.rooms[@actor.in_room].players[@actor.name].nil?.should == true
    end
  end
  describe "#add_room" do
    context "with a room with a globally unique id" do
      before :each do
        @added = @world.add_room RubyMud::Feature::Room.new 123
      end
      it "should add the room to the world" do
        @added.should == true
        @world.rooms[123].nil?.should == false
      end
    end
    context "with a room with an existing id" do
      before :each do
        @added = @world.add_room RubyMud::Feature::Room.new 1
      end
      it "should not add the room to the world" do
        @added.should == false
      end
    end
  end
end