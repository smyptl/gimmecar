class Command::ReportsController < ApplicationController

  def index
    @report = Services::Command::Reports::Revenue.fetch

    render xlsx: @report.file_name, template: 'command/excel.axlsx'
  end
end
