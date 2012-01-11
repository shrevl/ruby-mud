require 'ruby-mud/feature/exit'

describe RubyMud::Feature::Exit do
  before :each do
    @exit_room_id = 1
    @exit = RubyMud::Feature::Exit.new @exit_room_id
  end
  context "after initialization" do
    it "should have its exit room id set" do
      @exit.room_id.should == 1
    end
  end
end