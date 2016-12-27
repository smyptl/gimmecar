class Lib::TypeCast::String

  def self.type_cast(value)
    value = value.to_s.strip
    value.blank? ? nil : value
  end
end
