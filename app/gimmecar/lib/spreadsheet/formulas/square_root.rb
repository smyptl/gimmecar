class Lib::Spreadsheet::Formulas::SquareRoot < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length == 1
  end

  def formula(args)
    "SQRT(#{args[0]})"
  end

end
