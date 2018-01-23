class Lib::Spreadsheet::Formulas::Range < Lib::Spreadsheet::Formulas::Base

  private

  def validate
    case args
    when Array
      raise ArgumentError if args.length != 2
    when Hash
      raise ArgumentError unless args.has_key?(:cells) || args.has_key?(:rows) || args.has_key?(:columns)
    else
      raise ArgumentError
    end
  end

  def formula(args)
    case
    when args.first.is_a?(Array) && args.last.is_a?(Array)
      "#{args.first.first}:#{args.last.last}"
    else
      "#{args.first}:#{args.last}"
    end
  end

end
