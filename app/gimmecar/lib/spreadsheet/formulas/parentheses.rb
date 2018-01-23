class Lib::Spreadsheet::Formulas::Parentheses < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length == 1
  end

  def formula(args)
    "(#{args[0]})"
  end
end
