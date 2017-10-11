class Services::Admin::Vehicles < Lib::Services::Base

  def initialize(location_id)
    @location_id = location_id
  end

  def fetch
    Location.find(@location_id).vehicles.map do |v|
      {
        :id             => v.id,
        :make_model     => v.make_model,
        :vehicle_type   => ActiveSupport::Inflector.titleize(v.vehicle_type),
        :license_number => v.license_number,
        :vin            => v.vin,
        :status         => v.status,
      }
    end
  end
end
