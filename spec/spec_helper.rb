require 'simplecov'
SimpleCov.start 'rails'

require_relative '../lib/sy18nc.rb'

RSpec.configure do |config|
  config.failure_color = :magenta
  config.tty = true
  config.color = true
end
