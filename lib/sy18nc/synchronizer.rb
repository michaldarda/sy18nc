module Sy18nc
  class Synchronizer
    def initialize(*files)
      @options = files.sy18nc_extract_options!
      @path, @base, *@locales = files

      @path = File.expand_path(@path)

      @base = Locale.new("#{@path}/#{@base}")

      @locales = @locales.map do |tfile|
        Locale.new("#{@path}/#{tfile}")
      end
    end

    def synchronize_all
      @locales.each do |locale|
        if locale.synchronizable?
          locale.synchronize(@base)
          locale.save(@options.merge(filename: "#{@path}/#{locale.name}"))
        end
      end
    end
  end
end
