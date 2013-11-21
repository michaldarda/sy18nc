require "bundler/gem_tasks"
require "rake/testtask"

require_relative "lib/sy18nc"

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -I extra -r ./lib/sy18nc.rb"
end
