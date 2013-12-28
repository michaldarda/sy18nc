class String
  def marked_fixme?
    self =~ /g FIXME/
  end

  def mark_fixme!
    return self if marked_fixme?

    self.replace("#{self} g FIXME")
  end

  def append!(value)
    return self if self == ""

    self.replace("#{self}#{value}")
  end
end
