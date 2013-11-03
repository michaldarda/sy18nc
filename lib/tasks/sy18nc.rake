desc "Synchronizes translations according to config in initializer"
task :sy18nc => :environment do
  # synchronize the main files
  files = [Sy18nc.config.locales_dir]
  files << "#{Sy18nc.config.base_locale}.yml"
  files << Sy18nc.config.locales.map do |l|
    "#{l}.yml"
  end

  files.flatten!
  options = {}

  synchronizer = Sy18nc::Synchronizer.new(*files, options)
  synchronizer.synchronize_all

  # synchronize the rest of files
  Sy18nc.config.files.each do |s|
    files = [Sy18nc.config.locales_dir]
    files << "#{s}.#{Sy18nc.config.base_locale}.yml"
    files << Sy18nc.config.locales.map do |l|
      "#{s}.#{l}.yml"
    end

    files.flatten!
    options = {}

    synchronizer = Sy18nc::Synchronizer.new(*files, options)
    synchronizer.synchronize_all
  end
end
