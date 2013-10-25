require_relative 'spec_helper'

describe Sy18nc::Translation do
  before do
    @translation = Sy18nc::Translation.new("spec/fixtures/en.yml")
  end

  it "loads the yaml" do
    @translation.hash.wont_be_empty
    @translation.hash.must_be_kind_of Hash

    translation = Sy18nc::Translation.new("spec/fixtures/devise.tr.yml")
    translation.hash.wont_be_empty
    translation.hash.must_be_kind_of Hash
  end

  it "fetches the translation body" do
    @translation.body.wont_equal "en"
    @translation.body.must_be_kind_of Hash

    translation = Sy18nc::Translation.new("spec/fixtures/devise.tr.yml")
    translation.body.wont_be_empty
    translation.body.must_be_kind_of Hash
  end

  it "writes the translation to file" do
    refute File.exists?("en.yml")
    @translation.save
    assert File.exists?("en.yml")

    refute File.exists?("en.yml.bak")
    @translation.save(backup: true)
    assert File.exists?("en.yml.bak")

    refute File.exists?("translation_file.yml")
    @translation.save(filename: "translation_file")
    assert File.exists?("translation_file.yml")

    refute File.exists?("translation_file.yml.bak")
    @translation.save(filename: "translation_file", backup: true)
    assert File.exists?("translation_file.yml.bak")

    cleanup
  end

  it "converts translation to yml" do
    @translation.to_yaml.wont_be_empty
    @translation.to_yaml.must_be_kind_of String
    @translation.to_yaml.must_equal %q[---
en:
  promo:
    link1: "Hello"
    link2: "Hello"
]
  end

  it "synchronizes translations" do
    russian_translation = Sy18nc::Translation.new("spec/fixtures/ru.yml")
    russian_translation.synchronize(@translation)
    russian_translation.to_yaml.must_equal %q[---
ru:
  promo:
    link1: "Birbevoon"
    link2: "Hello" # FIXME
]
    @translation.to_yaml.lines.count.must_equal russian_translation.to_yaml.lines.count

    devise_en = Sy18nc::Translation.new("spec/fixtures/devise.en.yml")
    devise_tr = Sy18nc::Translation.new("spec/fixtures/devise.tr.yml")
    devise_en.to_yaml.lines.count.wont_equal devise_tr.to_yaml.lines.count

    devise_tr.synchronize(devise_en)
    devise_tr.to_yaml.lines.count.must_equal devise_en.to_yaml.lines.count
    devise_tr.to_yaml.must_equal(File.read(File.expand_path("spec/fixtures/results/devise.tr.yml")))
  end

  def cleanup
    %x[rm en.yml]
    %x[rm en.yml.bak]
    %x[rm translation_file.yml]
    %x[rm translation_file.yml.bak]
  end
end
