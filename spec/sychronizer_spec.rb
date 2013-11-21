require_relative 'spec_helper'

describe Sy18nc::Synchronizer do
  before do
    @synchronizer = Sy18nc::Synchronizer.new("spec/fixtures/", "en.yml" ,"ru.yml", backup: true)
  end

  after do
    %x[rm spec/fixtures/*.bak]
  end

  it "never touches the original translation" do
    before = File.read(File.expand_path("spec/fixtures/en.yml"))

    synchronizer = Sy18nc::Synchronizer.new("spec/fixtures/", "en.yml" ,"ru.yml", backup: true)
    synchronizer.synchronize_all
    after = File.read(File.expand_path("spec/fixtures/en.yml"))

    after.should eq before
  end

  it "creates missing translations" do
    File.exists?(File.expand_path("spec/fixtures/devise.es.yml")).should be_false
    synchronizer = Sy18nc::Synchronizer.new("spec/fixtures/", "devise.en.yml", "devise.es.yml")
    synchronizer.synchronize_all

    File.exists?(File.expand_path("spec/fixtures/devise.es.yml")).should be_true
    %x[rm spec/fixtures/devise.es.yml]
  end

  it "synchronizes translation only once" do
    3.times do
      @synchronizer.synchronize_all
      File.read(File.expand_path("spec/fixtures/ru.yml.bak")).should eq %q[---
ru:
  promo:
    link1: "Birbevoon"
    link2: "Hello" # FIXME
]
    end

    4.times do
      synchronizer = Sy18nc::Synchronizer.new("spec/fixtures/", "devise.en.yml", "devise.tr.yml", backup: true)
      synchronizer.synchronize_all
      File.read(File.expand_path("spec/fixtures/devise.tr.yml.bak")).should eq(File.read(File.expand_path("spec/fixtures/results/devise.tr.yml")))
    end
  end

  it "when backup option is set to true saves as a backup file and does not modify original files" do
    File.exists?(File.expand_path("spec/fixtures/ru.yml.bak")).should be_false
    @synchronizer.synchronize_all
    File.exists?(File.expand_path("spec/fixtures/ru.yml.bak")).should be_true
    File.read(File.expand_path("spec/fixtures/ru.yml.bak")).should eq %q[---
ru:
  promo:
    link1: "Birbevoon"
    link2: "Hello" # FIXME
]

    File.exists?(File.expand_path("spec/fixtures/devise.tr.yml.bak")).should be_false
    synchronizer = Sy18nc::Synchronizer.new("spec/fixtures/", "devise.en.yml", "devise.tr.yml", backup: true)
    synchronizer.synchronize_all
    File.exists?(File.expand_path("spec/fixtures/devise.tr.yml.bak")).should be_true
    File.read(File.expand_path("spec/fixtures/devise.tr.yml.bak")).should eq(File.read(File.expand_path("spec/fixtures/results/devise.tr.yml")))
  end
end
