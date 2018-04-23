class Command::ReportsController < Command::BaseController

  skip_before_action :authorize_api, only: :tax

  def index
    Services::Command::Reports::RevenueMonthly.retrieve(success, failure)
  end

  def tax
    @report = Services::Command::Reports::Spreadsheets::Revenue.retrieve!
    render xlsx: 'excel.axlsx', filename: @report.filename
  end
end
