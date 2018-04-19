class Command::Vehicles::RentalsController < Command::Vehicle::BaseController

  def index
    Services::Command::Vehicle::Rentals.new(vin: vin).retrieve(success, failure)
  end
end
