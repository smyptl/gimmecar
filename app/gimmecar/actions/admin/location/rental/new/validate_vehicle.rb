class Actions::Admin::Location::Rental::New::ValidateVehicle < Lib::Forms::Base
  include Actions::Admin::Location::Rental::New::Concerns::Vehicle

  private

  def pickup
    DateTime.now
  end

  def rental_period
    return unless pickup && drop_off
    return unless pickup.before?(drop_off)
    @rental_period ||= Lib::DateRange.new(pickup, drop_off)
  end

  def available_vehicle_ids
    location.available_vehicle_ids(vehicle_type: vehicle_type, date_range: rental_period)
  end

  def location
    @location ||= Location.find(params.fetch(:location_id))
  end

  def save
  end

  def success_args
  end
end
