require 'json'
require 'singleton'

module GmoClickBot
  class Config
    include Singleton
    def initialize
      config_filename = "#{ENV['HOME']}/.gmo_click_bot.json"
      unless File.exist?(config_filename)
        config_filename = File.expand_path('../../../config/config.json', __FILE__)
      end
      @settings = open(config_filename) do |f|
        JSON.load(f)
      end
    end

    def [](key)
      @settings[key]
    end
    def key?(key)
      @settings.key?(key)
    end

    def self.[](key)
      instance[key]
    end
    def self.key?(key)
      instance.key?(key)
    end
  end
end