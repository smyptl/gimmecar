class Lib::TypeCast::DateTime

  def self.type_cast(value)
    case value
    when Hash
      date = Lib::TypeCast::Date.type_cast(value.fetch(:date, nil))
      return unless date

      time = Lib::TypeCast::Time.type_cast(value.fetch(:time, nil))
      return unless time

      Lib::DateTime.create(date, time)
    when DateTime
      value
    end
  end
end
