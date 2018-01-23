class Lib::Spreadsheet::Formulas::Subtraction < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length > 1
  end

  def formula(args)
    args.join("-")
  end

end
