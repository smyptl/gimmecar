class Actions::Admin::Location::Rental::New::ValidateVehicle < Lib::Actions::Base
  include Actions::Admin::Location::Rental::New::Concerns::Vehicle

  private

  def pickup
    Time.current
  end

  def location
    @location ||= Location.find(params.fetch(:location_id))
  end

  def save
  end

  def success_args
  end
end
