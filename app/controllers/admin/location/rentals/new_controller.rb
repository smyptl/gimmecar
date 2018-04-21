class Admin::Location::Rentals::NewController < Admin::Location::BaseController

  def index
  end

  def rates
    Services::Admin::Location::Quote.new({
      pickup:       Time.current,
      drop_off:     params.fetch(:drop_off),
      vehicle_type: params.fetch(:vehicle_type)
    }).retrieve(success, failure, location_id: location.id)
  end

  def validate_drivers
    Actions::Admin::Location::Rental::New::ValidateDrivers.new(params).execute(success, failure, location_id: location.id)
  end

  def driver_search
    Services::Admin::Location::Drivers::Search.new(params).retrieve(success, failure)
  end

  def vehicles
    Services::Admin::Location::Vehicles::Available.new({
      location_id:  location.id,
      vehicle_type: params.fetch(:vehicle_type)
    }).retrieve(success, failure)
  end

  def validate_vehicle
    Actions::Admin::Location::Rental::New::ValidateVehicle.new(params).execute(success, failure, location_id: location.id )
  end

  def validate_financial_responsibility
    Actions::Admin::Location::Rental::New::ValidateFinancialResponsibility.new(params).execute(success, failure)
  end

  def validate_terms_and_conditions
    Actions::Admin::Location::Rental::New::ValidateTermsAndConditions.new(params).execute(success, failure)
  end

  def create
    Actions::Admin::Location::Rental::New::Create.new(params).execute(success, failure, location_id: location.id, user_id: current_user.id)
  end
end
