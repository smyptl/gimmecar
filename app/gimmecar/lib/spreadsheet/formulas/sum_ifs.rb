class Lib::Spreadsheet::Formulas::SumIfs < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    raise ArgumentError unless args.is_a?(Array)
    raise ArgumentError if args.length < 3
  end

  def formula(args)
    "SUMIFS(#{args.join(', ')})"
  end
end
