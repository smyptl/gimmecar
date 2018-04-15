class Services::Builders::RentalInvoice < Lib::Services::Builder

  component do |c|
    c.object :vehicle, component: Services::Builders::Vehicle

    c.object :location, as: :pickup_location do |o|
      o.attribute :description
    end

    c.object :driver do |o|
      o.attribute :name, as: :name_full
      o.attribute :license_number
      o.component Services::Builders::Address
    end

    c.object :additional_driver do |o|
      o.attribute :name, as: :name_full
      o.attribute :license_number
      o.component Services::Builders::Address
    end

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

    c.collection :rental_rates, nested: true, component: Services::Builders::LineItem

    c.object :deposit, component: Services::Builders::LineItem

    c.attributes :sub_total, :tax_collectable, :total, :combined_tax_rate
  end
end
