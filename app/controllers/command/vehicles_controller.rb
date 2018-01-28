class Command::VehiclesController < Command::BaseController

  before_action :authorize_vehicle, except: :index

  def index
    render status: 200, json: Services::Command::Vehicles.fetch
  end

  def show
    render status: 200, json: Services::Command::Vehicle.fetch(vin: vin)
  end

  private

  def authorize_vehicle
    raise Error404 unless Vehicle.exists?(vin: vin)
  end

  def vin
    params[:id]
  end
end
