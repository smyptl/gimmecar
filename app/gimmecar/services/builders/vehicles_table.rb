class Services::Builders::VehiclesTable < Lib::Services::Builder

  component do |c|
    c.attributes :make_model,
      :vin,
      :license_number,
      :status

    c.attribute :vehicle_type, output: -> (v) { ActiveSupport::Inflector.titleize(v.vehicle_type) }
  end
end
