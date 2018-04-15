class Logic::Metrics::Location::PricePerMile < SimpleDelegator

  attr_reader :vehicle_type

  def calculate
    Vehicle::TYPES.map do |vehicle_type|
      {
        vehicle_type: vehicle_type,
        metrics:      price_per_mile(vehicle_type)
      }
    end
  end

  private

  def price_per_mile(vehicle_type)
    rentals(vehicle_type).average_price_per_mile
  end

  def rentals(vehicle_types)
    Logic::Metrics::Rentals.new(rentals_closed.vehicle_type(vehicle_type))
  end
end
