class Admin::Location::Vehicles::StatusController < Admin::Location::Vehicles::BaseController

  def index
    render status: 200, json: { status: Vehicle.find_by(vin: vin).status }
  end

  def create
    Actions::Admin::Vehicles::ChangeStatus.new(params).execute(success, failure, { vin: vin })
  end
end
