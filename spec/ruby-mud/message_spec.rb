require 'ruby-mud/message'
require 'yaml'
require_relative '../test/test_world'

describe RubyMud::Message do
  before :all do
    TestWorld.reset
    @actor = RubyMud::World.instance.players["Actor"]
    @in_room = RubyMud::World.instance.players["InRoom"]
    @out_room = RubyMud::World.instance.players["OutOfRoom"]
    @messages = YAML.load_file("config/messages.yaml")
    @test_message = @messages["server"]["name_prompt"]
    @test_message_key = "server.name_prompt"
  end
  describe "#send_to_actor" do
    before :all do
      TestWorld.reset_players
      RubyMud::Message.send_to_actor @actor, @test_message_key
    end
    it "should send the message to the actor" do
      @actor.messages[0].should == @test_message
    end
    it "should not send a message to any other players" do
      @in_room.messages.length.should equal 0
      @out_room.messages.length.should equal 0
    end
  end
  describe "#send_to_room" do
    before :all do
      TestWorld.reset_players
      RubyMud::Message.send_to_room @actor.in_room, @test_message_key
    end
    it "should send the message to all players in the room" do
      @actor.messages[0].should == @test_message
      @in_room.messages[0].should == @test_message
    end
    it "should not send the message to players outside the room" do
      @out_room.messages.length.should equal 0
    end
  end
  describe "#send_global" do
    before :all do
      TestWorld.reset_players
      RubyMud::Message.send_global @test_message_key
    end
    it "should send the messages to all players" do
      RubyMud::World.instance.players.each do |p_name, player|
        player.messages[0].should == @test_message
      end
    end
  end
end
