class Lib::Spreadsheet::Formulas::Base

  def initialize(args)
    @args = args
    validate
  end

  def is_array_formula
    @array = true
    self
  end

  def parse(spreadsheet)
    str = "=#{parse_formula(spreadsheet)}"
    str = "{#{str}}" if @array

    str
  end

  def parse_formula(spreadsheet)
    @spreadsheet = spreadsheet

    case args
    when Array
      parsed_args = args.map { |a| default_parse_formula(a) }
    when Hash
      parsed_args = default_parse_formula(args)
    end

    formula(parsed_args)
  end

  private

  def default_parse_formula(arg)
    if arg.is_a?(Lib::Spreadsheet::Formulas::Base)
      arg.parse_formula(spreadsheet)
    else
      spreadsheet.parse(arg)
    end
  end

  def validate
    raise NotImplementedError
  end

  def formula
    raise NotImplementedError
  end

  def spreadsheet
    @spreadsheet || (raise NotImplementedError)
  end

  def args
    @args || (raise NotImplementedError)
  end
end
