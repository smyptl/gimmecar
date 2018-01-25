class Lib::Spreadsheet::Formulas::VLookup < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length == 4
  end

  def formula(args)
    "VLOOKUP(#{args.join(', ')})"
  end

end
