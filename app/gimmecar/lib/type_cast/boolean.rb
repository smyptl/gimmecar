class Lib::TypeCast::Boolean

  def self.type_cast(value)
    case value.class.name
    when "Boolean"
      value
    when "Integer"
      value == 1
    else
      value = value.to_s.strip
      value == "1" || value == "true"
    end
  end
end
