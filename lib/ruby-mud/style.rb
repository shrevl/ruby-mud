require 'yaml'
require 'term/ansicolor'

require_relative 'hash'
require_relative 'logging'

module RubyMud
  module Style
    begin
      @styles = YAML.load_file(File.expand_path "../../../config/styles.yaml", __FILE__)
    rescue
      RubyMud::Logging::Server.warn "Failed to load config/styles.yaml, text styling will be defaulted"
      @styles = {}
    end
    Default_Key = "default"
    Clear = Term::ANSIColor.clear
    
    def Style.get(style_key)
      style = @styles.get_multikey(style_key)
      if(style.nil?)
        style = Default_Style
      end
      style
    end
    
    private
    def self.transform(hash)
      hash.each do |key, value|
        if(value.is_a? Hash)
          transform(value)
        elsif(value.is_a? Array)
          a = []
          value.each do |style|
            a << Term::ANSIColor.method(style).call
          end
          hash[key] = a
        else
          a = []
          a << Term::ANSIColor.method(value).call
          hash[key] = a
        end
      end  
    end
    self.transform(@styles)
    Default_Style = @styles.get_multikey(Default_Key) || [ Term::ANSIColor.green ]
  end
end
