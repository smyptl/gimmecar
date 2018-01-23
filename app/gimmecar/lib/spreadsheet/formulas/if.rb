class Lib::Spreadsheet::Formulas::If < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a? Array
    raise ArgumentError unless args.length == 2 || args.length == 3
  end

  def formula(args)
    "IF(#{args.join(', ')})"
  end
end
