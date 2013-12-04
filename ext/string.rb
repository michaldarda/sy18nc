class String
  def sy18nc_marked_as_fixme?
    self =~ /g FIXME/
  end

  def sy18nc_mark_fixme!
    self if sy18nc_marked_as_fixme?

    self.replace("#{self} g FIXME")
  end

  def sy18nc_append!(val)
    return self if self == ""

    self.replace("#{self}#{val}")
  end
end
