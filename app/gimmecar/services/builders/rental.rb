class Services::Builders::Rental < Lib::Services::Builder

  component do |c|
    c.id :number
    c.attributes :number,
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
      :additional_driver_signature
  end
end
