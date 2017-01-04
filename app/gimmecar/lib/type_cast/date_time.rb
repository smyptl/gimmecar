class Lib::TypeCast::DateTime

  JSON_REGEX = /(-?\d+)[-](\d{2})[-](\d{2})?(\d{2})?.*/

  def self.type_cast(value)
    case value
    when String
      if value =~ JSON_REGEX
        begin
          DateTime.parse(value)
        rescue ArgumentError
          nil
        end
      end
    when DateTime
      value
    end
  end
end
