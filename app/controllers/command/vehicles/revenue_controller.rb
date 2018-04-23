class Command::Vehicles::RevenueController < Command::Vehicles::BaseController

  def index
    Services::Command::Vehicle::Revenue.new(vin: vin).retrieve(success, failure)
  end
end
