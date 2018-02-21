class Lib::Spreadsheet::Compiler::Spreadsheet

  def initialize(sheets)
    @sheets = sheets
    process_sheets
  end

  def set(args)
    @row_index    = args.fetch(:row_index)
    @column_index = args.fetch(:column_index)
    @sheet_id     = args.fetch(:sheet_id)
  end

  def parse(args)
    args[:sheet] ||= :current

    sheet = ""
    sheet = "'#{processed_sheets.fetch(args[:sheet]).fetch(:name)}'!" unless args.fetch(:sheet) == :current

    case
    when args[:cell]
      cell = parse_cell(args)
      raise ArgumentError, args.to_s if cell.nil?
      "#{sheet}#{::Axlsx::cell_r(cell.fetch(:column_index), cell.fetch(:row_index))}"

    when args[:row] && args[:column]
      "#{sheet}#{::Axlsx::cell_r(parse_column(args), parse_row(args))}"

    when args[:columns]
      row_index = parse_row(args)

      if args[:columns].is_a?(Array)
        args[:columns].map do |column|
          "#{sheet}#{::Axlsx::cell_r(parse_column({:sheet => args[:sheet], :column => column}), row_index)}"
        end
      else
        parse_sheet(args).fetch(:column_groups).fetch(args[:columns]).map do |column_index|
          "#{sheet}#{::Axlsx::cell_r(column_index, row_index)}"
        end
      end

    when args[:rows]
      column_index = parse_column(args)

      if args[:rows].is_a?(Array)
        args[:rows].map do |row|
          "#{sheet}#{::Axlsx::cell_r(column_index, parse_row({:sheet => args[:sheet], :row => row}))}"
        end
      else
        parse_sheet(args).fetch(:row_groups).fetch(args[:rows]).map do |row_index|
          "#{sheet}#{::Axlsx::cell_r(column_index, row_index)}"
        end
      end

    when args[:cells]
      raise NotImplementedError
    else
      raise ArgumentError
    end
  end

  private

  def sheets
    @sheets || (raise NotImplementedError)
  end

  def processed_sheets
    @processed_sheets ||= {}
  end

  def parse_sheet(args)
    if args.fetch(:sheet) == :current
      sheet = processed_sheets.fetch(@sheet_id)
    else
      sheet = processed_sheets.fetch(args[:sheet])
    end
  end

  def parse_cell(args)
    parse_sheet(args).dig(:cells, args.fetch(:cell))
  end

  def parse_row(args)
    row = args.fetch(:row)

    case row
    when Integer
      row
    when :current
      @row_index
    else
      parse_sheet(args).fetch(:rows).fetch(row)
    end
  end

  def parse_column(args)
    column = args.fetch(:column)

    case column
    when Integer
      column
    when :current
      @column_index
    else
      parse_sheet(args).fetch(:columns).fetch(column)
    end
  end

  def process_sheets
    sheets.each do |sheet|
      raise ArgumentError, "#{sheet.fetch(:id)} already set" if processed_sheets.has_key?(sheet.fetch(:id))
      process_sheet(sheet)
    end

  end

  def process_sheet(sheet)
    processed_sheets[sheet.fetch(:id)] = {
      :name          => sheet.fetch(:name),
      :cells         => {},
      :cell_groups   => {},
      :rows          => {},
      :row_groups    => {},
      :columns       => {},
      :column_groups => {}
    }

    sheet.fetch(:rows).each_with_index do |row, row_index|
      add(:rows, row[:id], row_index, sheet[:id])
      add_group(:row_groups, row[:group], row_index, sheet[:id])

      row.fetch(:cells).each_with_index do |cell, column_index|
        index = { :row_index => row_index, :column_index => column_index }
        add(:cells, cell[:id], index, sheet[:id])
        add_group(:cell_groups, cell[:group], index, sheet[:id])
      end
    end

    sheet.fetch(:columns).each_with_index do |column, column_index|
      add(:columns, column[:id], column_index, sheet[:id])
      add_group(:column_groups, column[:group], column_index, sheet[:id])
    end
  end

  def add(type, id, index, sheet_id)
    return if id.blank?

    if id.is_a?(Array)
      id.each { |i| add_rows(type, i, index, sheet_id) }
    else
      sheet = processed_sheets.dig(sheet_id, type)
      raise ArgumentError, "#{id} already set"  if sheet.has_key?(id)
      sheet[id] = index
    end
  end

  def add_group(type, id, index, sheet_id)
    return if id.blank?

    if id.is_a?(Array)
      id.each { |i| add_groups(type, i, index, sheet_id) }
    else
      sheet = processed_sheets.dig(sheet_id, type)
      (sheet[id] ||= []) << index
    end
  end
end
