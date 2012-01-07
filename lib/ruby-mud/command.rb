require_relative 'chat'

module Command
  @commands = {
                :say => Chat.method(:say),
              }
  
  def Command.execute(actor, cmd)
    cmds = Command.parse(cmd)
    if cmds.nil?
      puts "'#{cmd}' is not a well formed command."
      return false
    end
    c = cmds[0].intern
    args = cmds[1..cmds.length]
    command = @commands[c]
    unless command.nil?
      command[actor, args]
    else
      puts "Command '#{c}' not found."
      false
    end
  end
    
  private
  def Command.parse(cmd)
    in_quotes = false
    command = []
    s = 0
    i = 0
    cmd.each_char do |c|
      case c
      when '"'
        in_quotes = !in_quotes
      when ' '
        if !in_quotes
          val = cmd[s..i]
          val = val.strip
          if !val.empty?
            command.push val
          end
          s = i + 1
        end
      end
      i+=1
    end
    if s != i
      command.push cmd[s..i]
    end
    if(in_quotes)
      nil
    else
      command
    end
  end
end