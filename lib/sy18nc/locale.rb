# here I'm forcing it to use psych instead of standard Ruby parser
# this is to make this work with Ruby 1.9, probably won't be needed
# after upgrade to Ruby 2.0 or higher
require 'psych'

module Sy18nc
  class Locale
    attr_reader :name, :hash

    def initialize(file)
      # create new yaml (file and localition)
      create_new_locale_file(file) unless File.exists?(File.expand_path(file))

      # than we load this file
      @name = File.basename(file,".*")
      file  = File.read(File.expand_path(file))
      file  = replace_fixmes(file)

      # and we load yaml from file
      @hash = YAML.load(file)
      @hash.sy18nc_append!("foo \nbar")
    rescue Psych::SyntaxError => e
      puts "Problem with parsing #{name}, check if this is a valid YAML file http://yamllint.com/."
      puts e.message
    end

    def create_new_locale_file(file)
      # extracts name from locale file name
      # and creates an array ["devise", "en"]
      tname = file.match(/(([A-z]+\.)*)(yml)$/)[1].split(".")
      f = File.new(file, "w+")

      # uses fetched keys before to create a skeleton of locale
      locale_skeleton = Hash.sy18nc_nested_hash(tname.reverse)

      f.write(YAML.dump(locale_skeleton))
      f.close
    end

    def synchronizable?
      !!hash
    end

    def body
      hash[hash.keys.first]
    end

    def synchronize(other)
      body.sy18nc_deep_merge!(other.body)
      body.sy18nc_deep_delete_unused!(other.body)
    end

    def to_yaml
      # disable line wrapping
      yaml = YAML.dump(hash, line_width: -1)

      # hack to force double quotes in every value
      yaml.gsub!("foo \\nbar","")
      restore_fixmes(yaml)
    end

    def save(options = {})
      filename = options.fetch(:filename, "#{@name}")
      filename = "#{filename}.yml"
      filename = "#{filename}.bak" if options[:backup]

      file = File.new(filename, "w+")
      file.write(self.to_yaml)
      file.close
    end

    # hack to fetch yaml with the comments
    def replace_fixmes(file)
      file.gsub("\' # FIXME", " g FIXME\'")
        .gsub("\" # FIXME", " g FIXME\"")
        .gsub("# FIXME", "g FIXME")
    end

    # hack to restore fixmes
    def restore_fixmes(file)
      file.gsub("\sg FIXME\"", "\" # FIXME")
        .gsub("\sg FIXME\'", "\' # FIXME")
        .gsub("g FIXME", "# FIXME")
        .gsub("\"# FIXME\"", "# FIXME")
    end
  end
end
