require 'ruby-mud/command'
require_relative '../test/test_world'

describe RubyMud::Command do
  before :each do
    TestWorld.reset
    @actor = RubyMud::World.instance.players["Actor"]
  end
  describe "#execute" do
    it "should execute 'say words'" do
      RubyMud::Command.execute(@actor, "say words").should equal true
    end
    it "should execute 'quit'" do
      RubyMud::Command.execute(@actor, "quit").should equal true
    end
    it "should execute 'north'" do
      RubyMud::Command.execute(@actor, "north").should equal true
    end
    it "should not execute 'invalid command'" do
      RubyMud::Command.execute(@actor, "invalid command").should equal false
    end
  end
end
