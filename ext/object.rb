class Object
  def marked_fixme?
    false
  end

  def append!(value)
    self
  end

  def mark_fixme!
    self
  end
end
