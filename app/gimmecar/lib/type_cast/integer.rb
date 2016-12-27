class Lib::TypeCast::Integer

  def self.type_cast(value)
    case value
    when ::Fixnum || ::Bignum
      value
    when ::Float || ::BigDecimal
      value.to_i
    else
      value = value.to_s.gsub(/([^0-9.])/, "")
      value.blank? ? nil : value.to_i
    end
  end
end
