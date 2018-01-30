class Services::Admin::Vehicles::Available < Lib::Services::Base

  attr_reader :vehicle_type

  def initialize(location_id)
    @location_id = location_id
  end

  def for_vehicle_type(vehicle_type)
    @vehicle_type = vehicle_type
    self
  end

  def fetch
    Location.find(@location_id).available_vehicles(vehicle_type: vehicle_type, date_range: period).map do |v|
      {
        :id => v.id,
        :vin => v.vin,
        :license_number => v.license_number,
        :make => v.make,
        :model => v.model,
        :color => v.color,
      }
    end
  end
end
