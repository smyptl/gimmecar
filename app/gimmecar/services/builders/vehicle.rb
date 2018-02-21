class Services::Builders::Vehicle < Lib::Services::Builder

  component do |c|
    c.attributes :status,
      :vin,
      :license_number,
      :make,
      :model,
      :year,
      :color,
      :location_name

    c.attribute :vehicle_type, output: -> (v) { ActiveSupport::Inflector.titleize(v.vehicle_type) }
  end
end