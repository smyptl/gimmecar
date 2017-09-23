class Services::Admin::Location::Reservations < Lib::Services::Base

  def initialize(location_id)
    @location_id = location_id
  end

  def fetch
    Location.find(@location_id).reservations.map do |r|
      {
        :number   => r.number,
        :name     => r.driver_name,
        :vehicle  => ActiveSupport::Inflector.titleize(r.vehicle_type),
        :pickup   => r.pickup,
        :drop_off => r.drop_off,
      }
    end
  end
end
