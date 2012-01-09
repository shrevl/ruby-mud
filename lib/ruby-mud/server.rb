require 'socket'
require 'net/telnet'

require_relative 'command'
require_relative 'telnet'
require_relative 'world'
require_relative 'feature/player'
require_relative 'feature/room'

def receive_input(client)
  sanitize_input client.waitfor({"String" => "\n"})
end

def sanitize_input(input)
  result = String.new
  input.each_byte do |byte|
    #backspace
    if byte == 8
      result = result[0..-2]
    #remove characters outside of the "normal" 
    elsif byte >= 32 and byte <= 127
      result << byte
    end
  end
  result
end

def prompt_for_player(client)
  begin
    RubyMud::Telnet.send client, "Enter your name:"
    name = receive_input client
    unless name.empty?
      name.chomp!
      player = RubyMud::World.instance.players[name]
      if player.nil?
        player = RubyMud::Feature::Player.new(:client => client, :name => name)
        RubyMud::Message.send_global "[#{player.name} has joined the game]"
        RubyMud::Message.send_to_room player.in_room, "#{player.name} has appeared."
        return player
      elsif player.client.closed?
        RubyMud::Message.send_global "[#{player.name} has reconnected]"
        RubyMud::Message.send_to_room player.in_room, "The light has returned to #{player.name}'s eyes."
        player.client = client
        return player
      else
        RubyMud::Telnet.send client, "A player by that name is already active."
      end
    else
      #reading nothing from the socket indicates that the other end of the socket is closed
      #close our end of the socket
      client.close
    end
  end while !client.closed?
  nil
end

#Create the world
RubyMud::World.instance.add_room(RubyMud::Feature::Room.new 1)

server = TCPServer.open 2000

acceptThread = Thread.start do
  loop do
    Thread.start(server.accept) do |client|
      client = Net::Telnet.new("Proxy" => client)
      player = prompt_for_player client
      unless player.nil?
        RubyMud::World.instance.add_player player
        begin
          m = receive_input client
          unless m.nil?
            m.chomp!
            unless m.empty?
              RubyMud::Command.execute player, m
            end
          else
            #reading nothing from the socket indicates the other side has closed it's connection
            #we can safely disconnect our side of the socket
            player.disconnect
            RubyMud::Message.send_global "[#{player.name} has disconnected]"
            RubyMud::Message.send_to_room player.in_room, "#{player.name}'s eyes have lost their light."
            break
          end
        end while !client.closed?
      end
    end
  end
end

loop {
  m = gets.chomp
  if m == "shutdown"
    Thread.kill acceptThread
    RubyMud::World.instance.shutdown
    server.close
    break
  elsif m == "thread"
    puts "Listing threads:"
    Thread.list.each { |t| p t }
  end
}