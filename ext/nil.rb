class << nil
  def append!(val); end
  def mark_fixme!; end
end

class << false
  def append!(val)
    to_s.append!(val)
  end

  def mark_fixme!
    to_s.mark_fixme!
  end
end

class << true
  def append!(val)
    to_s.append!(val)
  end

  def mark_fixme!
    to_s.mark_fixme!
  end
end
