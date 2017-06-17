class Admin::Location::VehiclesController < Admin::Location::BaseController

  def index
    render status: 200, json: Services::Admin::Vehicles.fetch(location.id)
  end
end
