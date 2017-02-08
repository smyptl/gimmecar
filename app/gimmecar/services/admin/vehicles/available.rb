class Services::Admin::Vehicles::Available < Lib::Services::Base

  def initialize(location_id)
    @location_id = location_id
  end

  def fetch
    Location.find(@location_id).available_vehicles(period).map do |v|
      {
        :licence_number => v.licence_number,
        :make           => v.make,
        :model          => v.model,
        :color          => v.color
      }
    end
  end
end
