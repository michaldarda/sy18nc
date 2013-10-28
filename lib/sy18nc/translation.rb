module Sy18nc
  class Translation
    attr_reader :name, :hash

    def initialize(file)
      @name = File.basename(file,".*")

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
      hash.append!("foo \nbar")
    end

    def synchronizable?
      !!hash
    end

    def body
      hash[hash.keys.first]
    end

    def synchronize(other)
      body.deep_merge!(other.body)
    end

    def to_yaml
      # disable line wrap
      yaml = YAML.dump(hash, line_width: -1)

      # force double quotes
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
      file = File.read(File.expand_path(file))
      file = file.gsub("\' # FIXME", " g FIXME\'")
      file = file.gsub("\" # FIXME", " g FIXME\"")
      file = file.gsub("# FIXME", "g FIXME")
      file
    end

    # little trick:
    # restore fixmes
    def restore_fixmes(file)
      file.gsub!("\sg FIXME\"", "\" # FIXME")
      file.gsub!("\sg FIXME\'", "\' # FIXME")
      file.gsub!("g FIXME", "# FIXME")
      file.gsub!("\"# FIXME\"", "# FIXME")
      file
    end
  end
end
