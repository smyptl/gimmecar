class Lib::Spreadsheet::Row

  def initialize(sheet, default_options = {})
    @sheet           = sheet
    @default_options = default_options
  end

  def value(value, options = {})
    add_cell({ :value => value }.merge(merge_default_options(options)))
  end

  def formula(formula, options = {})
    add_cell({ :formula => formula }.merge(merge_default_options(options)))
  end

  def blank_cell(number = 1, options = {})
    number.times do
      value(nil, options)
    end
  end

  def column(name, id, options = {})
    sheet.column(name, id, options)
    value(name, options)
  end

  def fetch
    output = {}
    output[:cells]  = cells
    output[:group]  = default_options.fetch(:group)  if default_options.fetch(:group, nil)
    output[:id]     = default_options.fetch(:id)     if default_options.fetch(:id, nil)
    output[:height] = default_options.fetch(:height) if default_options.fetch(:height, nil)
    output
  end

  private

  def cells
    @cells ||= []
  end

  def add_cell(arg)
    cells << arg
  end

  def sheet
    @sheet
  end

  def default_options
    @default_options || {}
  end

  def merge_default_options(options)
    default_options.select { |k, _| ![:id, :group, :height].include?(k) }.deep_merge(options) do |key, default_value, other_value|
      case key.to_sym
      when :style
        default_value = [default_value] unless default_value.is_a?(Array)
        other_value   = [other_value]   unless other_value.is_a?(Array)

        default_value + other_value
      else
        other_value
      end
    end
  end
end
