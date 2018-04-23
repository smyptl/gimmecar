class Lib::Spreadsheet::Compiler::Height

  DEFAULT = 20

  class << self
    def parse(name)
      case name
      when nil
        nil
      when Lib::Attributes::TypeCast.integer(name)
        name
      else
        const_get(name.to_s.upcase)
      end
    end
  end
end
