desc "Synchronizes translations according to config in initializer"
task :sy18nc => :environment do
  Sy18nc.config.synchronizable.each do |s|
    files = [Sy18nc.config.locales_dir]
    files << "#{s}.#{Sy18nc.config.base_locale}.yml"
    files << Sy18nc.config.locales.map do |l|
      "#{s}.#{l}.yml"
    end

    files.flatten!

    synchronizer = Sy18nc::Synchronizer.new(*files)
    synchronizer.synchronize_all
  end
end
