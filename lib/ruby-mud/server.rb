require 'socket'
require_relative 'command'
require_relative 'world'
require_relative 'feature/player'
require_relative 'feature/room'

def prompt_for_player(client)
  begin
    client.puts "Enter your name:"
    name = client.recv 100
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
        client.puts "A player by that name is already active."
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
      player = prompt_for_player client
      unless player.nil?
        RubyMud::World.instance.add_player player
        begin
          m = client.recv 100
          unless m.empty?
            m.chomp!
            RubyMud::Command.execute player, m
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