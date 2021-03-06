module Sy18nc
  class << self
    attr_accessor :configuration

    def config
      @configuration ||= Configuration.new
    end

    def configure
      yield(config)
    end
  end

  class Configuration
    attr_accessor :base_locale, :locales_dir, :files, :locales, :backup

    def initialize
      @base_locale = "en"
      @locales_dir = "#{Dir.pwd}/config/locales"
      @backup      = false
      @locales     = []
      @files       = []
    end
  end
end
