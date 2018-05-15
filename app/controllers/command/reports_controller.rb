class Command::ReportsController < Command::BaseController

  skip_before_action :authorize_api, only: :tax

  def index
  end

  def revenue
    Services::Command::Reports::RevenueMonthly.retrieve(success, failure)
  end

  def vehicles
    Services::Command::Reports::Vehicles.retrieve(success, failure)
  end

  def deposits
    Services::Command::Reports::DepositsUnreturned.retrieve(success, failure)
  end

  def tax
    @report = Services::Command::Reports::Spreadsheets::Revenue.retrieve!
    render xlsx: 'excel.axlsx', filename: @report.filename
  end
end
