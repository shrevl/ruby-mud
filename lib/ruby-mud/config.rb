require 'yaml'
require_relative 'hash'

module RubyMud
  module Config
    @config = YAML.load_file(File.expand_path "../../../config/config.yaml", __FILE__) || {}
    Client_Timeout = @config.get_multikey("client.timeout") || 600 
    Server_Port = @config.get_multikey("server.port") || 5555
  end
end