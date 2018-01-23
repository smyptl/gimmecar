class Lib::Spreadsheet::Formulas::Sum < Lib::Spreadsheet::Formulas::Base

  def validate
    raise ArgumentError unless args.is_a? Array
    raise ArgumentError unless args.length > 0
  end

  def formula(args)
    "SUM(#{args.join(', ')})"
  end
end
