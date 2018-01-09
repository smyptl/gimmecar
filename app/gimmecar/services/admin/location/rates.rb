class Services::Admin::Location::Rates < Lib::Services::Base

  attr_reader :location

  def initialize(location_id)
    @location = Location.find(location_id)
  end

  def fetch
    output = []

    ::Vehicle::TYPES.each do |vehicle_type|
      output << {
        :vehicle_type => vehicle_type,
        :default_rate => location.default_rate_for(vehicle_type).amount,
        :rates        => location.rates.where(vehicle_type: vehicle_type, date: period.range).map { |r| { date: r.date, amount: r.amount }}
      }
    end

    output
  end
end
