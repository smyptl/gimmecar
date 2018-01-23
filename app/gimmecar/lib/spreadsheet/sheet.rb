class Lib::Spreadsheet::Sheet

  attr_accessor :show_grid_lines

  def initialize(name, id = nil, options = {})
    @name    = name
    @id      = (id || name.to_slug.underscore).to_sym
    @options = options
  end

  def column(name, id = nil, options = {})
    id = name.to_slug.underscore.to_sym unless id
    id = id.to_sym
    raise ArgumentError, "#{id.to_s} already taken." if column_ids.include?(id)

    columns << {:name => name, :id => id, group: options[:group], :options => options}
  end

  def blank_row(number = 1, options = {})
    number.times do
      row(options) { |r| r.blank_cell }
    end
  end

  def row_for_each(items, options = {})
    items.each do |item|
      row = new_row(options)
      yield row, item if block_given?
      add_row(row.fetch)
    end
  end

  def row_for_each_with_index(items, options = {})
    items.each_with_index do |item, index|
      row = new_row(options)
      yield row, item, index if block_given?
      add_row(row.fetch)
    end
  end

  def row(options = {})
    row = new_row(options)
    yield row if block_given?
    add_row(row.fetch)
  end

  def fetch
    {
      :name    => @name,
      :id      => @id,
      :columns => columns,
      :rows    => rows,
    }
  end

  private

  def rows
    @rows ||= []
  end

  def add_row(row)
    rows << row
  end

  def new_row(options)
    Lib::Spreadsheet::Row.new(self, options)
  end

  def columns
    @columns ||= []
  end

  def column_ids
    columns.map { |c| c.fetch(:id) }
  end

  def options
    @options ||= {}
  end
end
