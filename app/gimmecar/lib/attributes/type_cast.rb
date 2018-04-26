class Lib::Attributes::TypeCast

  TIME_REGEX = /(-?\d+)[-](\d{2})[-](\d{2})?(\d{2})?.*/
  DATE_REGEX = /^((((0[13578])|([13578])|(1[02]))[\/](([1-9])|([0-2][0-9])|(3[01])))|(((0[469])|([469])|(11))[\/](([1-9])|([0-2][0-9])|(30)))|((2|02)[\/](([1-9])|([0-2][0-9]))))[\/]\d{4}$|^\d{4}$/

  class << self
    def boolean(value)
      case value.class.name
      when "Boolean"
        value
      when "Integer"
        value == 1
      else
        value = string(value)
        value == "1" || value == "true"
      end
    end

    def date(value)
      return value if value.is_a?(Date)

      value = string(value)

      if value =~ TIME_REGEX
        parse = TIME_REGEX.match(value)
        value = "#{parse[2]}/#{parse[3]}/#{parse[1]}"
      end

      if value =~ DATE_REGEX
        Date.strptime(value, "%m/%d/%Y")
      end
    end

    def time(value)
      case value
      when String
        if value =~ TIME_REGEX
          begin
            Time.zone.parse(value)
          rescue ArgumentError
            nil
          end
        end
      when Time
        value
      when ActiveSupport::TimeWithZone
        value
      when DateTime
        value.to_time
      end
    end

    def value(value)
      value
    end

    def integer(value)
      case value
      when ::Integer
        value
      when ::Float || ::BigDecimal
        value.to_i
      else
        value = value.to_s.gsub(/([^0-9.])/, "")
        value.blank? ? nil : value.to_i
      end
    end

    def string(value)
      value = value.to_s.strip
      value.blank? ? nil : value
    end

    def symbol(value)
      value = string(value)
      value.blank? ? nil : value.to_sym
    end

    def signature(value)
      value
    end

    def document(value)
      value = file(value)

      if value && value.content_type == 'application/pdf'
       value
      end
    end

    def image(value)
      value = file(value)

      if value && value.content_type.include?('image')
        value
      end
    end

    private

    def file(value)
      if value.class == ActionDispatch::Http::UploadedFile
        value
      end
    end
  end
end
