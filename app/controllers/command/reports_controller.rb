class Command::ReportsController < Command::BaseController

  def index
    @report = Services::Command::Reports::Revenue.retrieve

    render xlsx: @report.file_name, template: 'command/excel.axlsx'
  end
end
