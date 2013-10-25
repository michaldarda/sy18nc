require_relative 'spec_helper'

describe Sy18nc::Synchronizer do
  def setup
    @synchronizer = Sy18nc::Synchronizer.new("spec/fixtures/en.yml", "ru.yml", backup: true)
  end

  def teardown
    %x[rm spec/fixtures/*.bak]
  end

  it "With no arguments synchronizes all the translations in the rails apps /config/locales dir" do
  end

  it "Never touches the original translations" do
  end

  it "It synchronizes translation only once" do
    3.times do
      @synchronizer.synchronize_all
      File.read(File.expand_path("spec/fixtures/ru.yml.bak")).must_equal %q[---
ru:
  promo:
    link1: "Birbevoon"
    link2: "Hello" # FIXME
]
    end

    4.times do
      synchronizer = Sy18nc::Synchronizer.new("spec/fixtures/devise.en.yml", "devise.tr.yml", backup: true)
      synchronizer.synchronize_all
      File.read(File.expand_path("spec/fixtures/devise.tr.yml.bak")).must_equal(File.read(File.expand_path("spec/fixtures/results/devise.tr.yml")))
    end
  end

  it "Produces the correct output for various translation combinations" do
  end

  it "When backup option is set to true saves as a backup file and not modify original files" do
    refute File.exists?(File.expand_path("spec/fixtures/ru.yml.bak"))
    @synchronizer.synchronize_all
    assert File.exists?(File.expand_path("spec/fixtures/ru.yml.bak"))
    File.read(File.expand_path("spec/fixtures/ru.yml.bak")).must_equal %q[---
ru:
  promo:
    link1: "Birbevoon"
    link2: "Hello" # FIXME
]

    refute File.exists?(File.expand_path("spec/fixtures/devise.tr.yml.bak"))
    synchronizer = Sy18nc::Synchronizer.new("spec/fixtures/devise.en.yml", "devise.tr.yml", backup: true)
    synchronizer.synchronize_all
    assert File.exists?(File.expand_path("spec/fixtures/devise.tr.yml.bak"))
    File.read(File.expand_path("spec/fixtures/devise.tr.yml.bak")).must_equal(File.read(File.expand_path("spec/fixtures/results/devise.tr.yml")))
  end
end
