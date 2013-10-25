module Sy18nc
  class Synchronizer
    def initialize(*files)
      @options = files.extract_options!

      @base, *@translations = files
      @path = File.expand_path(File.dirname(@base))

      @base = Translation.new(@base)
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
