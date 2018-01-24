class Services::Command::Vehicles < Lib::Services::Base

  def initialize()
  end

  def fetch
    Vehicle.all.map do |v|
      {
        :id             => v.id,
        :make_model     => v.make_model,
        :vehicle_type   => ActiveSupport::Inflector.titleize(v.vehicle_type),
        :location_name  => v.location_name,
        :license_number => v.license_number,
        :vin            => v.vin,
        :status         => v.status,
      }
    end
  end
end
