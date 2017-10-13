class Admin::Location::Vehicles::StatusController < Admin::Location::Vehicles::BaseController

  def index
    v = Vehicle.find_by(vin: vin)

    render status: 200, :json => { status: v.status }
  end

  def create
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Actions::Admin::Vehicles::ChangeStatus.new(params.require(:status)).execute(success, failure, { vin: vin })
  end
end
