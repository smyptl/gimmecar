class Lib::Spreadsheet::Base

  def initialize(name)
    @name = name
    yield(self) if block_given?
  end

  def add_sheet(name, id = nil)
    sheet = Lib::Spreadsheet::Sheet.new(name, id)
    yield sheet
    sheets << sheet.retrieve
  end

  def compile(workbook)
    Lib::Spreadsheet::Compiler::Base.new(workbook).retrieve(sheets: sheets)
  end

  def file_name
    @name.to_slug
  end

  private

  def sheets
    @sheets ||= []
  end
end
