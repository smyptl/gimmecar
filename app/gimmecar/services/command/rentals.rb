class Services::Command::Rentals < Lib::Services::Base

  def initialize
  end

  def fetch
    ::Rental.open.map do |r|
      {
        :status               => r.status,
        :number               => r.number,
        :name                 => r.driver_name,
        :vehicle              => r.vehicle_make_model,
        :pickup               => r.pickup,
        :drop_off             => r.drop_off,
        :pickup_location_name => r.pickup_location_name,
      }
    end
  end
end
