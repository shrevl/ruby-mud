require 'yaml'
require 'term/ansicolor'

require_relative 'hash'

module RubyMud
  module Style
    @styles = YAML.load_file(File.expand_path "../../../config/styles.yaml", __FILE__)
    Default_Key = "default"
    Clear = Term::ANSIColor.clear
    
    def Style.get(style_key)
      style = @styles.get_multikey(style_key)
      if(style.nil?)
        style = @styles.get_multikey(Default_Key)
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
  end
end
