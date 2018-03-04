class Command::ReportsController < Command::BaseController

  def index
    Services::Command::Reports::RentalsPerMonth.retrieve(success, failure)
  end
end
