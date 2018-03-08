class Lib::Spreadsheet::Compiler::Base

  def initialize(workbook)
    @workbook = workbook
  end

  def retrieve(inputs)
    @sheets = inputs.fetch(:sheets)
    compile
  end

  private

  def workbook
    @workbook
  end

  def sheets
    @sheets ||= []
  end

  def spreadsheet
    @spreadsheet ||= Lib::Spreadsheet::Compiler::Spreadsheet.new(sheets)
  end

  def compile
    sheets.each { |sheet| compile_sheet(sheet) }
  end

  def compile_sheet(sheet)
    workbook.add_worksheet(name: sheet.fetch(:name)) do |worksheet|
      # Covers up grid lines
      worksheet.sheet_view.show_grid_lines = false unless sheet[:show_gird_lines]

      # Compile each row
      sheet.fetch(:rows).each_with_index { |r, index| compile_row(worksheet, sheet, r, index) }

      # Compile each column
      sheet.fetch(:columns).each_with_index { |c, index| compile_column(worksheet, sheet, c, index) }
    end
  end

  def compile_row(worksheet, sheet, row, row_index)
    cells  = []
    styles = []

    row.fetch(:cells).each_with_index do |cell, column_index|

      if cell.has_key?(:value)
        cells << cell.fetch(:value)
      else
        spreadsheet.set({
          row_index:    row_index,
          column_index: column_index,
          sheet_id:     sheet.fetch(:id)
        })

        cells << cell.fetch(:formula).parse(spreadsheet)
      end

      styles << workbook.styles.add_style(Lib::Spreadsheet::Compiler::Style.parse(cell.fetch(:style, :default)))

      case cell[:merge_cells]
      when :to_end
        worksheet.merge_cells "#{Axlsx::cell_r(column_index, row_index)}:#{Axlsx::cell_r(longest_column_index(sheet), row_index)}"
      end
    end

    worksheet.add_row(cells, style: styles, height: Lib::Spreadsheet::Compiler::Height.parse(row.fetch(:height, nil)))
  end

  def compile_column(worksheet, sheet, column, column_index)
    options = column.fetch(:options)

    # Set the column widths
    worksheet.column_info[column_index].width  = options.fetch(:width)  if options.fetch(:width, nil)

    # Hide columns
    worksheet.column_info[column_index].hidden = options.fetch(:hidden) if options.fetch(:hidden, false)
  end

  def longest_column_index(sheet)
    sheet.fetch(:rows).map { |r| r.fetch(:cells).size }.max - 1
  end
end
