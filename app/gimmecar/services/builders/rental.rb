class Services::Builders::Rental < Lib::Services::Builder

  component do |c|
    c.values [
      :number,
      :status,
      :notes,
      :pickup_location_id,
      :pickup,
      :pickup_odometer,
      :pickup_fuel,
      :drop_off_location_id,
      :drop_off,
      :drop_off_odometer,
      :drop_off_fuel,
      :collision_damage_waiver,
      :driver_financial_responsibility_signature,
      :additional_driver_financial_responsibility_signature,
      :driver_signature,
      :additional_driver_signature,
    ]

    c.object :driver,            component: Services::Builders::Driver
    c.object :additional_driver, component: Services::Builders::Driver
    c.object :vehicle,           component: Services::Builders::VehiclesTable
  end
end
