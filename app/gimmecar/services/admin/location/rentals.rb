class Services::Admin::Location::Rentals < Lib::Services::Base

  def initialize(location_id)
    @location_id = location_id
  end

  def fetch
    Location.find(@location_id).open_rentals.map do |r|
      {
        :number   => r.number,
        :name     => r.driver_name,
        :vehicle  => r.vehicle_make_model,
        :pickup   => r.pickup,
        :drop_off => r.drop_off,
      }
    end
  end
end
