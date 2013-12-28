class String
  def marked_fixme?
    self =~ /g FIXME/
  end

  def mark_fixme!
    return self if marked_fixme?

    self.append!(" g FIXME")
  end

  def append!(value)
    return self if empty?

    self << value
  end
end
