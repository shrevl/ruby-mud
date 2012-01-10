require 'logger'
require 'socket'
require 'net/telnet'

require_relative 'command'
require_relative 'telnet'
require_relative 'world'
require_relative 'feature/player'
require_relative 'feature/room'

logger = Logger.new STDOUT
logger.level = Logger::DEBUG

def receive_input(client)
  begin
    #return output once a newline has been sent
    #timeout after 10 minutes without a message being sent
    sanitize_input client.waitfor({"String" => "\n", "Timeout" => 600})
  rescue TimeoutError
    nil
  end
end

def sanitize_input(input)
  if input.nil?
    return nil
  end
  result = String.new
  input.each_byte do |byte|
    #backspace
    if byte == 8
      result = result[0..-2]
    else
      result << byte
    end
  end
  result
end

def prompt_for_player(client)
  begin
    RubyMud::Message.send_to_client client, "server.name_prompt"
    name = receive_input client
    unless name.nil?
      name.chomp!
      player = RubyMud::World.instance.players[name]
      if player.nil?
        player = RubyMud::Feature::Player.new(:client => client, :name => name)
        RubyMud::Message.send_global "player.global.join", player.name
        RubyMud::Message.send_to_room player.in_room, "player.room.join", player.name
        return player
      elsif player.client.sock.closed?
        RubyMud::Message.send_global "player.global.reconnect", player.name
        RubyMud::Message.send_to_room player.in_room, "player.room.reconnect", player.name
        player.client = client
        return player
      else
        RubyMud::Message.send_to_client client, "server.player_active"
      end
    else
      #reading nothing from the socket indicates that the other end of the socket is closed
      #close our end of the socket
      client.sock.close
    end
  end while !client.sock.closed?
  nil
end

#Create the world
RubyMud::World.instance.add_room(RubyMud::Feature::Room.new 1)

logger.info "Starting RubyMud server on port 2000"
server = TCPServer.open 2000
logger.debug "RubyMud server is up" 

logger.debug "Starting connection thread"
acceptThread = Thread.start do
  loop do
    Thread.start(server.accept) do |client|
      addr = client.peeraddr
      network_id = "[#{addr[2]} #{addr[1]}]"
      logger.info "#{network_id} Connection accepted"
      client = Net::Telnet.new("Proxy" => client)
      logger.debug "#{network_id} Telnet socket proxy created"
      player = prompt_for_player client
      begin
        unless player.nil?
          logger.debug "#{network_id} Logged in as #{player.name}"
          RubyMud::World.instance.add_player player
          logger.debug "#{player.name} added to the world"
          begin
            m = receive_input client
            unless m.nil?
              m.chomp!
              logger.debug "#{player.name} sent '#{m}'"
              unless m.empty?
                logger.debug "#{player.name} executing '#{m}'"
                RubyMud::Command.execute player, m
              end
            else
              #reading nothing from the socket indicates the other side has closed it's connection
              #we can safely disconnect our side of the socket
              logger.info "#{player.name} has sent no input, disconnecting"
              player.disconnect
              RubyMud::Message.send_global "player.global.disconnect", player.name
              RubyMud::Message.send_to_room player.in_room, "player.room.disconnect", player.name
              break
            end
          end while !client.sock.closed?
          logger.info "#{player.name}'s socket has been closed"
        end
      rescue => e
        logger.error "Error raised: #{e}"
        player.disconnect
      end
    end
  end
end

logger.debug "Starting input thread"
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