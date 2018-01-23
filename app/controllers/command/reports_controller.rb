class Command::ReportsController < ApplicationController

  def index
    @report = Services::Command::Reports::Revenue.new.fetch

    render xlsx: 'Revenue', template: 'command/reports/revenue.axlsx'
  end
end
