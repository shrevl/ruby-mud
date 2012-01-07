require 'ruby-mud/command'
require 'ruby-mud/player'

describe Command do
  player = Player.new
  player.name = "Player"
  it "should execute 'say words'" do
    Command.execute(player, "say words").should equal true
  end
  it "should not execute 'invalid command'" do
    Command.execute(player, "invalid command").should equal false
  end
end
