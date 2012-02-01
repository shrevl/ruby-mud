require 'ruby-mud/feature/direction'

describe RubyMud::Feature::Direction do
  describe "#reverse" do
    it "should reverse 'north' to 'south'" do
      RubyMud::Feature::Direction.reverse(:north).should == :south
    end
    it "should reverse 'south' to 'north'" do
      RubyMud::Feature::Direction.reverse(:south).should == :north
    end
    it "should reverse 'east' to 'west'" do
      RubyMud::Feature::Direction.reverse(:east).should == :west
    end
    it "should reverse 'west' to 'east'" do
      RubyMud::Feature::Direction.reverse(:west).should == :east
    end
    it "should return nil on an invalid direction" do
      RubyMud::Feature::Direction.reverse(:invalid).nil?.should == true
    end
  end
end