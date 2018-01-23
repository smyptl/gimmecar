class Lib::Spreadsheet::Formulas::Or < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError unless args.length == 2
  end

  def formula(args)
    "OR(#{args[0]}, #{args[1]})"
  end
end
