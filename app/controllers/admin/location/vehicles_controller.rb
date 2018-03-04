class Admin::Location::VehiclesController < Admin::Location::BaseController

  before_action :authorize_vehicle, except: :index

  def index
    Services::Admin::Location::Vehicles.retrieve(success, failure, location_id: location.id)
  end

  def show
    Services::Admin::Location::Vehicle.new(vin: vin).retrieve(success, failure)
  end

  private

  def authorize_vehicle
    raise Error404 unless @location.vehicles.exists?(vin: vin)
  end

  def vin
    params[:id]
  end
end
