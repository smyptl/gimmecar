class Lib::Spreadsheet::Base

  def initialize(name)
    @name = name
  end

  def add_sheet(name, id = nil, options = {})
    sheet = Lib::Spreadsheet::Sheet.new(name, id, options)
    yield sheet
    sheets << sheet.fetch
  end

  def fetch
    {
      :sheets => sheets
    }
  end

  def compile(workbook)
    Lib::Spreadsheet::Compiler::Base.new(workbook).fetch(fetch)
  end

  private

  def sheets
    @sheets ||= []
  end
end
