class Array
  # Extracts options from a set of arguments. Removes and returns the last
  # element in the array if it's a hash, otherwise returns a blank hash.
  #
  #   def options(*args)
  #     args.sy18nc_extract_options!
  #   end
  #
  #   options(1, 2)           # => {}
  #   options(1, 2, :a => :b) # => {:a=>:b}
  def sy18nc_extract_options!
    if last.is_a?(Hash) && last.sy18nc_extractable_options?
      pop
    else
      {}
    end
  end

  def sy18nc_append!(val)
    self.each do |v|
      v.sy18nc_append!(val)
    end

    self
  end

  def sy18nc_mark_fixme!
    self.each do |v|
      v.sy18nc_mark_fixme!
    end

    self
  end
end
