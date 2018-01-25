class Lib::Spreadsheet::Formulas::Value < Lib::Spreadsheet::Formulas::Base

  def parse_formula(spreadsheet)
    args[0]
  end

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length == 1
  end

end
