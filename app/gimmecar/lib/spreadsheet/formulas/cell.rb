class Lib::Spreadsheet::Formulas::Cell < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    case args
    when Array
      raise ArgumentError if args.length < 1
    when Hash
      raise ArgumentError unless args.has_key?(:cell) || args.has_key?(:row) && args.has_key?(:column)
    else
      raise ArgumentError
    end
  end

  def formula(args)
    args
  end
end
