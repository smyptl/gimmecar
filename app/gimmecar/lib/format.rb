class Lib::Format

  class << self

    def date(date)
      date.blank? ? "-" : date.strftime("%-m/%-d/%Y")
    end
  end
end
