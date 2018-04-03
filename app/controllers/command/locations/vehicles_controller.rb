class Command::Locations::VehiclesController < Command::Locations::BaseController

  def index
    Services::Command::Location::Vehicles.new(slug: slug).retrieve(success, failure)
  end
end
