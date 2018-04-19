class Command::Vehicles::RevenueController < Command::Vehicle::BaseController

  def index
    Services::Command::Vehicle::Revenue.new(vin: vin).retrieve(success, failure)
  end
end
