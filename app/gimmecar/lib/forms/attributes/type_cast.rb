class Lib::Forms::Attributes::TypeCast
  class << self
    def typecast_attribute(value, rule)
      if rule.is_a?(Hash)
        typecast_hash(value, rule)
      else
        type_cast(value, rule)
      end
    end

    def typecast_hash(values, rules)
      output = []
      values.each do |value|
        return if value.nil?
        typecasted_values = {}
        rules.each do |k, v|
          typecasted_value = typecast_attribute(value.fetch(k, nil), v.to_s)
          typecasted_values[k] = typecasted_value unless typecasted_value.blank?
        end
        output << typecasted_values unless typecasted_values.blank?
      end unless values.blank?
      output
    end

    def type_cast(value, type)
      "Lib::TypeCast::#{type.to_s.camelize}".constantize.type_cast(value)
    end
  end
end
