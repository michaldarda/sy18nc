require_relative 'spec_helper'

describe Array do
  it "extracts options" do
    a = [1, 2, 3, 4, { option: true, option2: false }]
    a.sy18nc_extract_options!.should eql({ option: true, option2: false })
    a.should eql([1,2,3,4])

    a.sy18nc_extract_options!.should eql({})
    a.should eql([1,2,3,4])
  end

  it "appends" do
    a = ["hello", "world"]

    a.sy18nc_append!("appended_string")

    a.should eql(["helloappended_string", "worldappended_string"])
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

    @hash.sy18nc_append!("appended_string").should eql(appended_hash)

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

    hash2.sy18nc_append!("appended_string").should eql(appended_hash2)
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

    @hash.sy18nc_mark_fixme!
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

    other_hash.sy18nc_deep_merge!(@hash).should eql(result)
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

    hash2.sy18nc_deep_delete_unused!(hash1).should eql(hash1)
  end

  describe String do
    it "marks fixme" do
      "Hello".sy18nc_mark_fixme!.should eql("Hello g FIXME")

      "Hello g FIXME".sy18nc_mark_fixme!.should eql("Hello g FIXME")

      "*hello_world".sy18nc_mark_fixme!.should eql("*hello_world")
    end
  end
end
