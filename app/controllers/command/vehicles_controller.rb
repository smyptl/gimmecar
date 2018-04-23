class Command::VehiclesController < Command::BaseController

  before_action :authorize_vehicle, except: :index

  def index
    Services::Command::Vehicles.retrieve(success, failure)
  end

  def show
    Services::Command::Vehicle::Information.new(vin: vin).retrieve(success, failure)
  end

  private

  def authorize_vehicle
    raise Error404 unless Vehicle.exists?(vin: vin)
  end

  def vin
    params[:id]
  end
end
