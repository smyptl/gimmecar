class Lib::Spreadsheet::Formulas::Average < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length > 0
  end

  def formula(args)
    "AVERAGE(#{args.join(', ')})"
  end

end
