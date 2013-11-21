if Rails.env.development?
  Sy18nc.configure do |c|
    c.locales = []
    c.files   = []
  end
end
