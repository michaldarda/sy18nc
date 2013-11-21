require_relative "spec_helper"

describe Sy18nc do
  it "is configurable" do
    Sy18nc.config.base_locale.should eql("en")
    Sy18nc.config.locales_dir.should eql("#{Dir.pwd}/config/locales")
    Sy18nc.config.files.should eql([])
    Sy18nc.config.locales.should eql([])

    Sy18nc.configure do |c|
      c.base_locale = "ru"
      c.locales_dir = "spec/fixtures"
      c.backup = true
      c.files = ["code", "devise", "doorkeeper"]
      c.locales = ["en", "es", "fr", "de"]
    end

    Sy18nc.config.base_locale.should eql("ru")
    Sy18nc.config.locales_dir.should eql("spec/fixtures")
    Sy18nc.config.backup.should eql(true)
    Sy18nc.config.files.should eql(["code", "devise", "doorkeeper"])
    Sy18nc.config.locales.should eql(["en", "es", "fr", "de"])
  end
end
