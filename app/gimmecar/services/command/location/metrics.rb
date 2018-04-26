class Services::Command::Location::Metrics < Lib::Services::Base

  attributes do |a|
    a.string :slug
  end

  def output
    Vehicle::TYPES.map do |vehicle_type|
      rentals = Logic::Metrics::Rentals.new(location.rentals_closed.vehicle_type(vehicle_type))

      {
        vehicle_type:   vehicle_type,
        price_per_mile: rentals.average_price_per_mile,
        average_rate:   rentals.average_rate
      }
    end
  end

  def location
    Location.find_by(slug: slug)
  end
end
