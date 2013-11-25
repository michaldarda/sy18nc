require_relative 'spec_helper'

describe Sy18nc::Locale do
  before do
    @locale = Sy18nc::Locale.new("spec/fixtures/en.yml")
  end

  it "loads the yaml" do
    @locale.hash.should_not be_empty
    @locale.hash.should be_a_kind_of(Hash)

    locale = Sy18nc::Locale.new("spec/fixtures/devise.tr.yml")
    locale.hash.should_not be_empty
    locale.hash.should be_a_kind_of(Hash)
    locale.synchronizable?.should be_true
  end

  it "is not synchronizable when YAML is not valid" do
    t = Sy18nc::Locale.new("spec/fixtures/not_valid.yml")
    t.synchronizable?.should be_false
  end

  it "fetches the locale body" do
    @locale.body.should_not eql("en")
    @locale.body.should be_a_kind_of(Hash)

    locale = Sy18nc::Locale.new("spec/fixtures/devise.tr.yml")
    locale.body.should_not be_empty
    locale.body.should be_a_kind_of(Hash)
  end

  it "writes the locale to file" do
    File.exists?("en.yml").should be_false
    @locale.save
    File.exists?("en.yml").should be_true

    File.exists?("en.yml.bak").should be_false
    @locale.save(backup: true)
    File.exists?("en.yml.bak").should be_true

    File.exists?("locale_file.yml").should be_false
    @locale.save(filename: "locale_file")
    File.exists?("locale_file.yml").should be_true

    File.exists?("locale_file.yml.bak").should be_false
    @locale.save(filename: "locale_file", backup: true)
    File.exists?("locale_file.yml.bak").should be_true

    cleanup
  end

  it "converts locale to yml" do
    @locale.to_yaml.should_not be_empty
    @locale.to_yaml.should be_a_kind_of(String)
    @locale.to_yaml.should eql(%q[---
en:
  promo:
    link1: "Hello"
    link2: "Hello"
    link3: "Hello"
])
  end

  it "synchronizes locales" do
    russian_locale = Sy18nc::Locale.new("spec/fixtures/ru.yml")
    russian_locale.synchronize(@locale)
    russian_locale.to_yaml.should eql(%q[---
ru:
  promo:
    link1: "Birbevoon"
    link3: "Hello" # FIXME
    link2: "Hello" # FIXME
])
    @locale.to_yaml.lines.count.should eql(russian_locale.to_yaml.lines.count)

    devise_en = Sy18nc::Locale.new("spec/fixtures/devise.en.yml")
    devise_tr = Sy18nc::Locale.new("spec/fixtures/devise.tr.yml")
    devise_en.to_yaml.lines.count.should_not eql(devise_tr.to_yaml.lines.count)

    devise_tr.synchronize(devise_en)
    devise_tr.to_yaml.lines.count.should eql(devise_en.to_yaml.lines.count)
    devise_tr.to_yaml.should eql(File.read(File.expand_path("spec/fixtures/results/devise.tr.yml")))
  end

  it "deletes unused keys" do
    locale1 = Sy18nc::Locale.new("spec/fixtures/devise.en.yml")
    locale2 = Sy18nc::Locale.new("spec/fixtures/devise.tr.yml")

    locale1.synchronize(locale2)
  end

  def cleanup
    %x[rm en.yml]
    %x[rm en.yml.bak]
    %x[rm locale_file.yml]
    %x[rm locale_file.yml.bak]
  end
end
