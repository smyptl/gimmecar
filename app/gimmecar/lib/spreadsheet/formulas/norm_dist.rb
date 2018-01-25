class Lib::Spreadsheet::Formulas::NormDist < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length == 1
  end

  def formula(args)
    "NORMSDIST(#{args[0]})"
  end

end
