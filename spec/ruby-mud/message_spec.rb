require 'ruby-mud/message'
require 'ruby-mud/telnet'
require 'yaml'
require_relative '../test/test_world'

shared_examples_for "send_to_actor" do
  it "should send the message to the actor" do
    @actor.messages[0].should == @test_message
  end
  it "should not send a message to any other players" do
    @in_room.messages.length.should equal 0
    @out_room.messages.length.should equal 0
  end
end

describe RubyMud::Message do
  before :all do
    TestWorld.reset
    @actor = RubyMud::World.instance.players["Actor"]
    @in_room = RubyMud::World.instance.players["InRoom"]
    @out_room = RubyMud::World.instance.players["OutOfRoom"]
    @test_message = "This is the test message."
  end
  describe "#send_to_actor" do
    before :all do
      TestWorld.reset_players
      RubyMud::Message.send_to_actor @actor, @test_message
    end
    it_behaves_like "send_to_actor"
  end
end

describe RubyMud::Message::Builder do
  before :all do
    @newline = RubyMud::Telnet.newline
    @test_message = "A message"
  end
  before :each do
    @builder = RubyMud::Message::Builder.new
  end
  describe "#<<" do    
    it "should add a message to be built" do
      @builder << @test_message
      @builder.build.should == @test_message
    end
    
    it "should allow for chaining of itself" do
      @builder << @test_message << @test_message << @test_message
      @builder.build.should == @test_message + @newline + @test_message + @newline + @test_message
    end
  end
  describe "#build" do
    it "should build an empty message if no messages have been added" do
      @builder.build.empty?.should == true
    end
    it "should build a single message with no newlines if only one message was added" do
      @builder << @test_message
      @builder.build.should == @test_message
    end
    it "should build a message comprised of the combination of all given messages, separated by newlines" do
      @builder << @test_message
      @builder.build.should == @test_message
      @builder << @test_message
      @builder.build.should == @test_message + @newline + @test_message
      @builder << @test_message
      @builder.build.should == @test_message + @newline + @test_message + @newline + @test_message
    end
  end
end