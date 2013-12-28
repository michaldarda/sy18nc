class Hash
  def self.skeleton(keys)
    head, *tail = keys
    return {} if head.nil?
    { head => skeleton(tail) }
  end

  # borrowed from http://api.rubyonrails.org/, customized for own needs

  # Merge the two nested hashes, if the key is missing,
  # we replace it and deeply mark fixme
  def deep_merge_fixme!(other_hash)
    other_hash.each_pair do |other_key, other_value|
      self_value = self[other_key]
      self[other_key] = if self_value.is_a?(Hash) && other_value.is_a?(Hash)
        self_value.deep_merge_fixme!(other_value)
      elsif self_value.nil? || self_value.marked_fixme?
        other_value.mark_fixme!
      else
        self_value
      end
    end

    deep_delete_unused!(other_hash)
  end

  def deep_delete_unused!(other_hash)
    self.each_pair do |k, v|
      if other_hash[k].nil?
        delete(k)
      elsif self[k].is_a?(Hash)
        self[k].deep_delete_unused!(other_hash[k])
      end
    end
  end

  # Appends the val to the every string in nested hash
  def append!(value)
    self.each_pair do |k, v|
      v.append!(value)
    end
  end

  # Marks the nested hash values with g FIXME
  # see also mark_fixme! in string
  def mark_fixme!
    self.each_pair do |k, v|
      v.mark_fixme!
    end
  end

  # By default, only instances of Hash itself are extractable.
  # Subclasses of Hash may implement this method and return
  # true to declare themselves as extractable. If a Hash
  # is extractable, Array#extract_options! pops it from
  # the Array when it is the last element of the Array.
  def extractable_options?
    instance_of?(Hash)
  end
end
