class Command::Vehicles::RegistrationsController < Command::Vehicles::BaseController

  def index
    Services::Command::Vehicle::Registrations.new(vin: vin).retrieve(success, failure)
  end
end
