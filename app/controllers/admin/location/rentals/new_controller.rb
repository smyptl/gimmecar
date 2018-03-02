class Admin::Location::Rentals::NewController < Admin::Location::BaseController

  def index
  end

  def rates
    Services::Admin::Location::Quote.new({
      pickup:       Time.now,
      drop_off:     params[:rental].fetch(:drop_off),
      vehicle_type: params[:rental].fetch(:vehicle_type)
    }).retrieve(success, failure, location: location)
  end

  def validate_drivers
    Actions::Admin::Location::Rental::New::ValidateDrivers.new({
      drop_off:              params[:rental][:drop_off],
      driver_id:             params[:rental][:driver_id],
      driver:                params[:rental][:driver],
      add_additional_driver: params[:rental][:add_additional_driver],
      additional_driver_id:  params[:rental][:additional_driver_id],
      additional_driver:     params[:rental][:additional_driver],
    }).execute(success, failure, params)
  end

  def driver_search
    Services::Admin::Location::Drivers::Search.new(params.require(:search)).retrieve(success, failure)
  end

  def vehicles
    Services::Admin::Vehicles::Available.new({
      location_id:  location.id,
      vehicle_type: params[:rental].fetch(:vehicle_type)
    }).retrieve(success, failure)
  end

  def validate_vehicle
    Actions::Admin::Location::Rental::New::ValidateVehicle.new({
      drop_off:        params[:rental][:drop_off],
      vehicle_type:    params[:rental][:vehicle_type],
      vehicle_id:      params[:rental][:vehicle_id],
      pickup_odometer: params[:rental][:pickup_odometer],
      pickup_fuel:     params[:rental][:pickup_fuel],
    }).execute(success, failure, location_id: location.id )
  end

  def validate_financial_responsibility
    Actions::Admin::Location::Rental::New::ValidateFinancialResponsibility.new({
      add_additional_driver:                                params[:rental][:add_additional_driver],
      driver_financial_responsibility_signature:            params[:rental][:driver_financial_responsibility_signature],
      additional_driver_financial_responsibility_signature: params[:rental][:additional_driver_financial_responsibility_signature],
    }).execute(success, failure, params)
  end

  def validate_terms_and_conditions
    Actions::Admin::Location::Rental::New::ValidateTermsAndConditions.new({
      add_additional_driver:       params[:rental][:add_additional_driver],
      driver_signature:            params[:rental][:driver_signature],
      additional_driver_signature: params[:rental][:additional_driver_signature],
    }).execute(success, failure, params)
  end

  def create
    Actions::Admin::Location::Rental::New::Create.new(params.require(:rental)).execute(success, failure, { location_id: location.id, user_id: current_user.id })
  end
end
