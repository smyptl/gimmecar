class Lib::TypeCast::Time

  TIME_REGEX = /(\d+)[:](\d+).(AM|PM)/

  def self.type_cast(value)
    return value if value.is_a?(Time)

    value = Lib::TypeCast::String.type_cast(value)

    if value =~ TIME_REGEX
      Time.strptime(value, '%I:%M %p').in_time_zone("Pacific Time (US & Canada)")
    end
  end
end
