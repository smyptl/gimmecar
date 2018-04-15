class Services::Command::Location::Metrics < Lib::Services::Base

  attributes do |a|
    a.string :slug
  end

  def output
    {
      price_per_mile: Logic::Metrics::Location::PricePerMile.new(location).calculate,
    }

  end

  def location
    Location.find_by(slug: slug)
  end
end
