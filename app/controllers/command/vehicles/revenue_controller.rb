class Command::Vehicles::RevenueController < Command::BaseController

  before_action :authorize_vehicle

  def index
    Services::Command::Vehicle::Revenue.new(vin: vin).retrieve(success, failure)
  end

  private

  def authorize_vehicle
    raise Error404 unless ::Vehicle.exists?(vin: vin)
  end

  def vin
    params[:vehicle_id]
  end
end
