class Command::VehiclesController < Command::BaseController

  def index
    render status: 200, json: Services::Command::Vehicles.fetch
  end
end
