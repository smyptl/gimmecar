class Lib::Spreadsheet::Formulas::Sum < Lib::Spreadsheet::Formulas::Base

  def validate
    raise ArgumentError if !args.is_a?(Array)
    raise ArgumentError if args.length == 0
  end

  def formula(args)
    args = [args] unless args.is_a?(Array)
    "SUM(#{args.join(', ')})"
  end
end
