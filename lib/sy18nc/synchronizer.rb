module Sy18nc
  class Synchronizer
    def initialize(*files)
      @options = files.extract_options!

      @path, @base, *@translations = files
      @path = File.expand_path(@path)

      @base = Translation.new("#{@path}/#{@base}")
      @translations = @translations.map do |tfile|
        Translation.new("#{@path}/#{tfile}")
      end
    end

    def synchronize_all
      @translations.each do |translation|
        if translation.synchronizable?
          translation.synchronize(@base)
          translation.save(@options.merge(filename: "#{@path}/#{translation.name}"))
        end
      end
    end
  end
end
