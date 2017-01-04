class Lib::DateTime

  def self.create(date, time)
    Time.use_zone("America/Los_Angeles") { Time.zone.parse().to_datetime }
  end
end
