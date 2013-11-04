require_relative "spec_helper"

describe Sy18nc do
  it "is configurable" do
    Sy18nc.config.base_locale.must_equal "en"
    Sy18nc.config.locales_dir.must_equal "#{Dir.pwd}/config/locales"
    Sy18nc.config.files.must_equal []
    Sy18nc.config.locales.must_equal []

    Sy18nc.configure do |c|
      c.base_locale = "ru"
      c.locales_dir = "spec/fixtures"
      c.backup = true
      c.files = ["code", "devise", "doorkeeper"]
      c.locales = ["en", "es", "fr", "de"]
    end

    Sy18nc.config.base_locale.must_equal "ru"
    Sy18nc.config.locales_dir.must_equal "spec/fixtures"
    Sy18nc.config.backup.must_equal true
    Sy18nc.config.files.must_equal ["code", "devise", "doorkeeper"]
    Sy18nc.config.locales.must_equal ["en", "es", "fr", "de"]
  end
end
