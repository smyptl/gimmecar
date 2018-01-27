class Admin::Location::VehiclesController < Admin::Location::BaseController

  before_action :authorize_vehicle, except: :index

  def index
    render status: 200, json: Services::Admin::Vehicles.fetch(location.id)
  end

  def show
    render status: 200, json: Services::Admin::Vehicle.fetch(vin: vin)
  end

  private

  def authorize_vehicle
    raise Error404 unless @location.vehicles.exists?(vin: vin)
  end

  def vin
    params[:id]
  end
end
