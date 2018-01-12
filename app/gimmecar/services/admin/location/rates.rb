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
        :rate         => location.rate_for(vehicle_type).amount,
      }
    end

    output
  end
end
