class Services::Admin::Vehicles::Available < Lib::Services::Base

  def initialize(location_id)
    @location_id = location_id
  end

  def fetch
    Location.find(@location_id).available_vehicles(period).map do |v|
      {
        :id             => v.id,
        :license_number => v.license_number,
        :make           => v.make,
        :model          => v.model,
        :color          => v.color
      }
    end
  end
end
