class String
  def sy18nc_marked_as_fixme?
    self =~ /g FIXME/
  end

  def sy18nc_mark_fixme!
    # skip if it is already marked or its an alias
    if sy18nc_marked_as_fixme? || self =~ /\*([a-z]*(\_)?)*/
      return self
    end

    self.replace("#{self} g FIXME")
  end

  def sy18nc_append!(val)
    return self if self == ""

    self.replace("#{self}#{val}")
  end
end
