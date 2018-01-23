class Lib::Spreadsheet::Formulas::Add < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    case args
    when Array
      raise ArgumentError if args.length < 2
    when Hash
      raise ArgumentError unless args.has_key?(:cells) || args.has_key?(:rows) || args.has_key?(:columns)
    else
      raise ArgumentError
    end
  end

  def formula(args)
    args.join("+")
  end
end
