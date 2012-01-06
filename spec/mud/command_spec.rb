require 'ruby-mud/command'

describe Command do
  it "should execute 'say words'" do
    Command.execute("say words") == true
  end
  it "should not execute 'invalid command'" do
    Command.execute("invalid command") == false
  end
end
