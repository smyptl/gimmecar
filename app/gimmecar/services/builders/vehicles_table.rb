class Services::Builders::VehiclesTable < Lib::Services::Builder

  component do |c|
    c.values :make_model,
      :vin,
      :license_number,
      :status

    c.value :vehicle_type, output: -> (v) { ActiveSupport::Inflector.titleize(v.vehicle_type) }
  end
end
