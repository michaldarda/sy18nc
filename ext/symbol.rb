class Symbol
  def append!(val)
    to_s.append!(val)
  end

  def mark_fixme!(val)
    to_s.mark_fixme!
  end
end
