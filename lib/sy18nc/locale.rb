require 'psych'

module Sy18nc
  class Locale
    attr_reader :name, :hash

    # a little helper, move to separate module
    def nested_hash(keys)
      head, *tail = keys
      return {} if head.nil?
      { head => nested_hash(tail) }
    end

    def initialize(file)
      # locale does not exists
      unless File.exists?(File.expand_path(file))
        # extracts name from locale file name
        # ["devise", "en"]
        tname = file.match(/(([A-z]+\.)*)(yml)$/)[1].split(".")
        f = File.new(file, "w+")

        # uses fetched keys before to create a skeleton of locale
        locale_skeleton = nested_hash(tname.reverse)

        f.write(YAML.dump(locale_skeleton))
        f.close
      end

      @name = File.basename(file,".*")

      file = File.read(File.expand_path(file))
      file = replace_fixmes(file)
    begin
      @hash = YAML.load(file)
    rescue Exception => e
      puts "Problem with parsing #{name}, check if this is a valid YAML file http://yamllint.com/."
      puts e.message
      return
    end

      # little hack
      # force double-quotes everywhere
      hash.sy18nc_append!("foo \nbar")
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
      # disable line wrap
      yaml = YAML.dump(hash, line_width: -1)

      # force double quotes in every value
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

    # little trick:
    # fetch with the comments
    def replace_fixmes(file)
      file.gsub("\' # FIXME", " g FIXME\'")
        .gsub("\" # FIXME", " g FIXME\"")
        .gsub("# FIXME", "g FIXME")
    end

    # little trick:
    # restore fixmes
    def restore_fixmes(file)
      file.gsub("\sg FIXME\"", "\" # FIXME")
        .gsub("\sg FIXME\'", "\' # FIXME")
        .gsub("g FIXME", "# FIXME")
        .gsub("\"# FIXME\"", "# FIXME")
    end
  end
end
