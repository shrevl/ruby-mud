require 'logger'

module RubyMud
  module Logging
    Server = Logger.new STDOUT
    Server.level = Logger::DEBUG
  end
end