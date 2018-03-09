class Services::Builders::RentalPrint < Lib::Services::Builder

  component do |c|
    c.object :vehicle, component: Services::Builders::Vehicle

    c.object :location, as: :pickup_location do |o|
      o.attribute :description
    end

    c.attributes :driver_name, :additional_driver_name
    c.attributes :pickup,
      :pickup_fuel,
      :pickup_odometer,
      :drop_off,
      :drop_off_fuel,
      :drop_off_odometer,
      :driver_financial_responsibility_signature,
      :additional_driver_financial_responsibility_signature,
      :driver_signature,
      :additional_driver_signature

    c.collection :rates, nested: true, component: Services::Builders::LineItem

    c.object :deposit, component: Services::Builders::LineItem

    c.attributes :sub_total, :tax_collectable, :total, :combined_tax_rate
  end
end