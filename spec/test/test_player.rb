require 'ruby-mud/feature/player'

require_relative 'test_client'

class TestPlayer < RubyMud::Feature::Player 
  def messages
    @client.messages
  end
  
  def reset
    @client = TestClient.new
  end
end