class Lib::Spreadsheet::Formula

  class << self
    def method_missing(type, value)
      "Lib::Spreadsheet::Formulas::#{type.to_s.camelize}".constantize.new(value)
    end
  end
end
