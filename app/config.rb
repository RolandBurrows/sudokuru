module Config

  DEBUG = ENV['DEBUG'].nil? ? nil : ENV['DEBUG'].to_s
  RUNTIME = ENV['RUNTIME'].nil? ? 60 : ENV['RUNTIME'].to_i

end
