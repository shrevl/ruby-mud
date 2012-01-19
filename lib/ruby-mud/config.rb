require 'yaml'
require_relative 'hash'

module RubyMud
  module Config
    begin
      @config = YAML.load_file(File.expand_path "../../../config/config.yaml", __FILE__) || {}
    rescue
      @config = {}
      RubyMud::Logging::Server.warn "Failed to load config/config.yaml, server configuration will be defaulted"
    end
    Client_Timeout = @config.get_multikey("client.timeout") || 600 
    Server_Port = @config.get_multikey("server.port") || 5555
    Server_Heartbeat = @config.get_multikey("server.heartbeat") || 10
    World_Starting_Room = @config.get_multikey("world.starting_room") || 1
  end
end