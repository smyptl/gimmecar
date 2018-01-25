class Lib::Spreadsheet::Formulas::Min < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length == 2 || args.length == 1
  end

  def formula(args)
    "MIN(#{args.join(', ')})"
  end

end
