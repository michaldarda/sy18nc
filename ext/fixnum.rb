class Fixnum
  def append!(val)
    to_s.append!(val)
  end

  def mark_fixme!
    to_s.mark_fixme!
  end
end
