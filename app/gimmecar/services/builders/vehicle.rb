class Services::Builders::Vehicle < Lib::Services::Builder

  component do |c|
    c.id :vin
    c.attributes :status,
      :vin,
      :license_number,
      :make,
      :model,
      :make_model,
      :year,
      :color,
      :location_name,
      :location_slug

    c.attribute :vehicle_type, output: -> (v) { ActiveSupport::Inflector.titleize(v.vehicle_type) }
  end
end
