class Command::Vehicles::AddRegistrationController < Command::Vehicle::BaseController

  def index
    success.call({})
  end

  def create
    Actions::Command::Vehicle::AddRegistration.new(vin: vin).retrieve(success, failure)
  end
end
