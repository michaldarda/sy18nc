require_relative 'spec_helper'

describe Sy18nc::Locale do
  before do
    @locale = Sy18nc::Locale.new("spec/fixtures/en.yml")
  end

  it "loads the yaml" do
    @locale.hash.wont_be_empty
    @locale.hash.must_be_kind_of Hash

    locale = Sy18nc::Locale.new("spec/fixtures/devise.tr.yml")
    locale.hash.wont_be_empty
    locale.hash.must_be_kind_of Hash
    assert locale.synchronizable?
  end

  it "is not synchronizable when YAML is not valid" do
    t = Sy18nc::Locale.new("spec/fixtures/not_valid.yml")
    refute t.synchronizable?
  end

  it "fetches the locale body" do
    @locale.body.wont_equal "en"
    @locale.body.must_be_kind_of Hash

    locale = Sy18nc::Locale.new("spec/fixtures/devise.tr.yml")
    locale.body.wont_be_empty
    locale.body.must_be_kind_of Hash
  end

  it "writes the locale to file" do
    refute File.exists?("en.yml")
    @locale.save
    assert File.exists?("en.yml")

    refute File.exists?("en.yml.bak")
    @locale.save(backup: true)
    assert File.exists?("en.yml.bak")

    refute File.exists?("locale_file.yml")
    @locale.save(filename: "locale_file")
    assert File.exists?("locale_file.yml")

    refute File.exists?("locale_file.yml.bak")
    @locale.save(filename: "locale_file", backup: true)
    assert File.exists?("locale_file.yml.bak")

    cleanup
  end

  it "converts locale to yml" do
    @locale.to_yaml.wont_be_empty
    @locale.to_yaml.must_be_kind_of String
    @locale.to_yaml.must_equal %q[---
en:
  promo:
    link1: "Hello"
    link2: "Hello"
]
  end

  it "synchronizes locales" do
    russian_locale = Sy18nc::Locale.new("spec/fixtures/ru.yml")
    russian_locale.synchronize(@locale)
    russian_locale.to_yaml.must_equal %q[---
ru:
  promo:
    link1: "Birbevoon"
    link2: "Hello" # FIXME
]
    @locale.to_yaml.lines.count.must_equal russian_locale.to_yaml.lines.count

    devise_en = Sy18nc::Locale.new("spec/fixtures/devise.en.yml")
    devise_tr = Sy18nc::Locale.new("spec/fixtures/devise.tr.yml")
    devise_en.to_yaml.lines.count.wont_equal devise_tr.to_yaml.lines.count

    devise_tr.synchronize(devise_en)
    devise_tr.to_yaml.lines.count.must_equal devise_en.to_yaml.lines.count
    devise_tr.to_yaml.must_equal(File.read(File.expand_path("spec/fixtures/results/devise.tr.yml")))


  end

  def cleanup
    %x[rm en.yml]
    %x[rm en.yml.bak]
    %x[rm locale_file.yml]
    %x[rm locale_file.yml.bak]
  end
end
