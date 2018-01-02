class Command::RentalsController < Command::BaseController

  def index
    render status: 200, json: Services::Command::Rentals.fetch
  end
end
