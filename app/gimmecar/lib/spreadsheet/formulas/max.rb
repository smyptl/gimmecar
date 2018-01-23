class Lib::Spreadsheet::Formulas::Max < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length == 1 || args.length == 2
  end

  def formula(args)
    "MAX(#{args.join(', ')})"
  end

end
