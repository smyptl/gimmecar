class Admin::Location::Rentals::NewController < Admin::Location::BaseController

  def rates
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Services::Admin::Rental::Rates.new(params.require(:rental).permit(:pickup, :drop_off)).execute(success, failure, params)
  end

  def vehicles
    render status: 200, json: Services::Admin::Vehicles::Available.new(location.id).during_period(params[:rental][:pickup], params[:rental][:drop_off]).fetch
  end

  def drivers
  end

  def summary
  end
end
