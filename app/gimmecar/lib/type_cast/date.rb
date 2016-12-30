class Lib::TypeCast::Date

  JSON_REGEX = /(-?\d+)[-](\d{2})[-](\d{2})?(\d{2})?.*/
  DATE_REGEX = /^((((0[13578])|([13578])|(1[02]))[\/](([1-9])|([0-2][0-9])|(3[01])))|(((0[469])|([469])|(11))[\/](([1-9])|([0-2][0-9])|(30)))|((2|02)[\/](([1-9])|([0-2][0-9]))))[\/]\d{4}$|^\d{4}$/

  def self.type_cast(value)
    return value if value.is_a?(Date)

    value = Lib::TypeCast::String.type_cast(value)

    if value =~ JSON_REGEX
      parse = JSON_REGEX.match(value)
      value = "#{parse[2]}/#{parse[3]}/#{parse[1]}"
    end

    if value =~ DATE_REGEX
      Date.strptime(value, "%m/%d/%Y").in_time_zone("Pacific Time (US & Canada)")
    end
  end
end
