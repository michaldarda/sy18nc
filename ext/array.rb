class Array
  # Extracts options from a set of arguments. Removes and returns the last
  # element in the array if it's a hash, otherwise returns a blank hash.
  #
  #   def options(*args)
  #     args.extract_options!
  #   end
  #
  #   options(1, 2)           # => {}
  #   options(1, 2, :a => :b) # => {:a=>:b}
  def extract_options!
    if last.is_a?(Hash) && last.extractable_options?
      pop
    else
      {}
    end
  end

  def append!(val)
    self.each do |v|
      v.append!(val)
    end

    self
  end

  def mark_fixme!
    self.each do |v|
      v.mark_fixme!
    end

    self
  end
end
