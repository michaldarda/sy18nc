desc "Synchronizes translations according to config in initializer"
task :sy18nc => :environment do
  options = Sy18nc.config.backup ? {backup: true} : {}

  # synchronize the main files
  # for example en.yml, de.yml, es.yml
  files = [Sy18nc.config.locales_dir]
  files << "#{Sy18nc.config.base_locale}.yml"
  files << Sy18nc.config.locales.map do |locale|
    "#{locale}.yml"
  end

  files.flatten!

  synchronizer = Sy18nc::Synchronizer.new(*files, options)
  synchronizer.synchronize_all

  # synchronize the rest of files
  # devise.en.yml, devise.de.yml, devise.es.yml
  Sy18nc.config.files.each do |file|
    files = [Sy18nc.config.locales_dir]
    files << "#{file}.#{Sy18nc.config.base_locale}.yml"
    files << Sy18nc.config.locales.map do |locale|
      "#{file}.#{locale}.yml"
    end

    files.flatten!

    synchronizer = Sy18nc::Synchronizer.new(*files, options)
    synchronizer.synchronize_all
  end
end
