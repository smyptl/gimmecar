class Command::Vehicles::RentalsController < Command::Vehicles::BaseController

  def index
    Services::Command::Vehicle::Rentals.new(vin: vin).retrieve(success, failure)
  end
end
