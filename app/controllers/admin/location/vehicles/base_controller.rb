class Admin::Location::Vehicles::BaseController < Admin::Location::BaseController

  before_action :authorize_vehicle

  def authorize_vehicle
    raise Error404 unless @location.vehicles.exists?(vin: vin)
  end

  def vin
    params[:vehicle_id]
  end
end
