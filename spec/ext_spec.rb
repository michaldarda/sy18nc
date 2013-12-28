require_relative 'spec_helper'

describe Object do
  describe "#marked_fixme?" do
    subject { Object.new.marked_fixme? }
    it { should be_false }
  end

  describe "#append!" do
    before { @object = Object.new.append!("somestring") }
    subject { @object }
    it { should eq @object }
  end

  describe "#mark_fixme!" do
    before { @object = Object.new.mark_fixme! }
    subject { @object }
    it { should eq @object }
  end
end

describe Array do
  describe "#extract_options!" do
    subject { [1, 2, 3, 4, options].extract_options! }

    context "when contains options" do
      let(:options) { { option: true, option2: false } }
      it { should eq options }
    end

    context "when contains no options" do
      let(:options) { nil }
      it { should be_empty }
    end
  end

  describe "#append!" do
    subject { ["hello", "world"].append!("appended_string") }
    it { should eq ["helloappended_string", "worldappended_string"] }
  end

  describe "#mark_fixme!" do
    subject { ["Hello", 1, 2, 3, "String"].mark_fixme! }
    it { should eq ["Hello g FIXME", 1, 2, 3, "String g FIXME"] }
  end
end

describe String do
  describe "#marked_fixme?" do
    subject { "Hello#{suffix}".marked_fixme? }

    context "when marked fixme" do
      let(:suffix) { "g FIXME" }
      it { should be_true }
    end

    context "when not marked fixme" do
      let(:suffix) { "" }
      it { should be_false }
    end
  end

  describe "#mark_fixme!" do
    subject { "Hello #{suffix}".mark_fixme! }

    context "already marked fixme" do
      let(:suffix) { "g FIXME" }
      it { should eq "Hello g FIXME" }
    end

    context "not marked yet" do
      let(:suffix) { "" }
      it { should eq "Hello  g FIXME" }
    end
  end

  describe "#append!" do
    subject { "#{string}".append!("hello") }
    context "empty" do
      let(:string) { "" }
      it { should be_empty }
    end

    context "any other string" do
      let(:string) { "helloworld" }
      it { should eq "helloworldhello" }
    end
  end
end

describe Hash do
  before do
    @hash = {
      :key1 => {
        key11: "Hello",
        key12: "Hello"
      },
      :key2 => {
        key21: "Hello",
        key22: {
          key221: "Hello",
          key222: {
            key2221: "Hello",
            key2222: "Hello"
          }
        }
      }
    }
  end

  it "deep appending the correct string" do
    appended_hash = {
      :key1 => {
        key11: "Helloappended_string",
        key12: "Helloappended_string"
      },
      :key2 => {
        key21: "Helloappended_string",
        key22: {
          key221: "Helloappended_string",
          key222: {
            key2221: "Helloappended_string",
            key2222: "Helloappended_string"
          }
        }
      }
    }

    @hash.append!("appended_string").should eql(appended_hash)

    hash2 = {
      :key1 => "helloworld",
      :key2 =>
        [
          "hello",
          "world"
        ]
      }

    appended_hash2 = {
      :key1 => "helloworldappended_string",
      :key2 =>
        [
          "helloappended_string",
          "worldappended_string"
        ]
      }

    hash2.append!("appended_string").should eql(appended_hash2)
  end

  it "deep marks fixme" do
    fixme_hash = {
      :key1 => {
        key11: "Hello g FIXME",
        key12: "Hello g FIXME"
      },
      :key2 => {
        key21: "Hello g FIXME",
        key22: {
          key221: "Hello g FIXME",
          key222: {
            key2221: "Hello g FIXME",
            key2222: "Hello g FIXME"
          }
        }
      }
    }

    @hash.mark_fixme!
    @hash.should eql(fixme_hash)
  end

  it "deep merges and marks fixme" do
    other_hash = {
      :key1 => {
        key11: "Hello",
      },
      :key2 => {
        key22: {
          key221: "Hello"
        }
      }
    }

    result = {
      :key1 => {
        key11: "Hello",
        key12: "Hello g FIXME"
      },
      :key2 => {
        key21: "Hello g FIXME",
        key22: {
          key221: "Hello",
          key222: {
            key2221: "Hello g FIXME",
            key2222: "Hello g FIXME"
          }
        }
      }
    }

    other_hash.deep_merge_fixme!(@hash).should eql(result)
  end

  it "deep deletes unused" do
    hash1 = {
      :key1 => {
        :key3 => {}
      }
    }

    hash2 = {
      :key1 => {
        :key2 => 1,
        :key3 => {
          :key4 => 1
        }
      }
    }

    hash2.deep_delete_unused!(hash1).should eql(hash1)
  end
end
