class Command::Vehicles::BaseController < Command::BaseController

  before_action :authorize_vehicle

  private

  def authorize_vehicle
    raise Error404 unless ::Vehicle.exists?(vin: vin)
  end

  def vin
    params[:vehicle_id]
  end
end
