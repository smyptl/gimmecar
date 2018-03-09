class Admin::Location::Vehicles::StatusController < Admin::Location::Vehicles::BaseController

  def index
    v = Vehicle.find_by(vin: vin)

    render status: 200, json: { status: v.status }
  end

  def create
    Actions::Admin::Vehicles::ChangeStatus.new(params.require(:status)).execute(success, failure, { vin: vin })
  end
end
