require_relative 'logging'

module RubyMud
  module Heart
    def Heart.pulse
      RubyMud::Logging::Server.debug "Heart pulse"      
    end
  end
end