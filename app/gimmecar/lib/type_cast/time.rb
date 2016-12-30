class Lib::TypeCast::Time

  TIME_REGEX = /(\d+)[:](\d+).(AM|PM)/

  def self.type_cast(value)
    return value if value.is_a?(Time)

    value = Lib::TypeCast::String.type_cast(value)

    if value =~ TIME_REGEX
      Time.use_zone("America/Los_Angeles") do
        Time.strptime(value, '%I:%M %p')
      end
    end
  end
end
