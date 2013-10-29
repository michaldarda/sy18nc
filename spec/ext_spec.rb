require_relative 'spec_helper'

describe Array do
  it "extracts options" do
    a = [1, 2, 3, 4, { option: true, option2: false }]
    a.extract_options!.must_equal({ option: true, option2: false })
    a.must_equal([1,2,3,4])

    a.extract_options!.must_equal({})
    a.must_equal([1,2,3,4])
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

    @hash.append!("appended_string").must_equal appended_hash
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
    @hash.must_equal fixme_hash
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

    other_hash.deep_merge!(@hash).must_equal result
  end

  describe String do
    it "marks fixme" do
      "Hello".mark_fixme!.must_equal("Hello g FIXME")

      "Hello g FIXME".mark_fixme!.must_equal("Hello g FIXME")

      "*hello_world".mark_fixme!.must_equal("*hello_world")
    end
  end
end
