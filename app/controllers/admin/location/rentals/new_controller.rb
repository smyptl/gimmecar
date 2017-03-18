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

    Services::Admin::Rates.new({ :pickup => DateTime.now, :drop_off => params[:rental].fetch(:drop_off) }).execute(success, failure, params)
  end

  def drivers
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Actions::Admin::Location::Rental::ValidateDrivers.new({
      :drop_off              => params[:rental][:drop_off],
      :driver_id             => params[:rental][:driver_id],
      :driver                => params[:rental][:driver],
      :add_additional_driver => params[:rental][:add_additional_driver],
      :additional_driver_id  => params[:rental][:additional_driver_id],
      :additional_driver     => params[:rental][:additional_driver],
    }).execute(success, failure, params)
  end

  def vehicles
    render status: 200, json: Services::Admin::Vehicles::Available.new(location.id).during_period(DateTime.now, params[:rental][:drop_off]).fetch
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

    Actions::Admin::Location::Rental::Create.new(params.require(:rental)).execute(success, failure, { location_id: location.id, user_id: current_user.id })
  end
end
