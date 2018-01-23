class Command::ReportsController < Command::ApplicationController

  def index
    @report = Services::Command::Reports::Revenue.new.fetch

    render filename: 'Revenue', template: 'command/reports/revenue.axlsx'
  end
end
