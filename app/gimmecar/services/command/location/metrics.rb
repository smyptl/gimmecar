class Services::Command::Location::Metrics < Lib::Services::Base

  attributes do |a|
    a.string :slug
  end

  def output
    Logic::Metrics::Location.new(location).average_rental_rate_per_month_by_vehicle_type
  end

  def location
    Location.find_by(slug: slug)
  end
end
