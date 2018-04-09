class Logic::Metrics::Location < SimpleDelegator

  def average_rental_rate_per_month_by_vehicle_type
    Vehicle::TYPES.map do |vehicle_type|
      {
        vehicle_type: vehicle_type,
        metrics:      Logic::Metrics::Rentals.new(rental_rates.where(invoice: rentals_pickup.vehicle_type(vehicle_type), date: last_12_months)).average_per_month
      }

    end
  end

  private

  def last_12_months
    end_of_this_month = Date.civil(Date.today.year, Date.today.month, -1)
    (end_of_this_month - 1.year)..(end_of_this_month)
  end
end
