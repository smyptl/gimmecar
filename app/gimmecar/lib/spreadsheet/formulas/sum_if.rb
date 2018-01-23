class Lib::Spreadsheet::Formulas::SumIf < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length == 3
  end

  def formula(args)
    "SUMIF(#{args[0]}, #{args[1]}, #{args[2]})"
  end

end
