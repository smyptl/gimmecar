class Command::Vehicles::AddRegistrationController < Command::Vehicles::BaseController

  def index
    success.call({})
  end

  def create
    Actions::Command::Vehicle::AddRegistration.new(params).execute(success, failure, vin: vin)
  end
end
