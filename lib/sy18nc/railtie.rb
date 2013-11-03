class Sy18ncRailtie < Rails::Railtie
  rake_tasks do
    load "#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/tasks/sy18nc.rake"
  end
end
