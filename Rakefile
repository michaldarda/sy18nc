require "bundler/gem_tasks"
require "rake/testtask"

require_relative "lib/sy18nc"

Rake::TestTask.new(:spec) do |t|
  t.libs.push "lib"
  t.test_files = FileList["spec/*_spec.rb"]
  t.verbose = true
end

task default: :spec

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -I extra -r ./lib/sy18nc.rb"
end
