class Services::Command::Vehicle < Lib::Services::Base

  attr_reader :vehicle

  def initialize(vin: nil, id: nil)
    case
    when vin
      @vehicle = ::Vehicle.find_by(vin: vin)
    when rental_id
      @vehicle = ::Vehicle.find(id)
    end
  end

  def fetch
    output = {}

    output[:vehicle_type]   = ActiveSupport::Inflector.titleize(vehicle.vehicle_type)
    output[:status]         = vehicle.status
    output[:vin]            = vehicle.vin
    output[:license_number] = vehicle.license_number
    output[:make]           = vehicle.make
    output[:model]          = vehicle.model
    output[:year]           = vehicle.year
    output[:color]          = vehicle.color
    output[:location_name]  = vehicle.location_name

    output
  end
end
