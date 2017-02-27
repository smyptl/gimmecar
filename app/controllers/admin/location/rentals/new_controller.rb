class Admin::Location::Rentals::NewController < Admin::Location::BaseController

  def index
  end

  def rates
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Services::Admin::Rates.new(params.require(:rental).permit(:pickup, :drop_off)).execute(success, failure, params)
  end

  def drivers
  end

  def vehicles
    render status: 200, json: Services::Admin::Vehicles::Available.new(location.id).during_period(params[:rental][:pickup], params[:rental][:drop_off]).fetch
  end

  def add_ons
  end

  def financial_responsibility
  end

  def terms_and_conditions
  end

  def create
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Actions::Admin::Location::Rental::Create.new(params.require('rental')).execute(success, failure, { location_id: location.id, user_id: current_user.id })
  end
end
