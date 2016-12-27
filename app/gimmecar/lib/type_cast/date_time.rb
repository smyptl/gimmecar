class Lib::TypeCast::DateTime

  TIME_REGEX = /(\d+)[:](\d+).(AM|PM)/

  def self.type_cast(value)
    case value
    when Hash
      date = Lib::TypeCast::Date.type_cast(value.fetch(:date, nil))
      return unless date

      time = value.fetch(:time, nil)
      return unless time =~ TIME_REGEX
      time = Time.strptime(time, '%I:%M %p').in_time_zone("Pacific Time (US & Canada)")
      return unless time

      DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, time.zone)
    when DateTime
      value
    end
  end
end
