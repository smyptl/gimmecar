class Services::Admin::Location::Rental::Print < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental do |o|
      o.object :vehicle, component: Services::Builders::Vehicle

      o.object :location, as: :pickup_location do |o|
        o.attribute :description
      end

      o.attributes :driver_name, :additional_driver_name
      o.attributes :pickup,
        :pickup_fuel,
        :pickup_odometer,
        :drop_off,
        :drop_off_fuel,
        :drop_off_odometer,
        :driver_financial_responsibility_signature,
        :additional_driver_financial_responsibility_signature,
        :driver_signature,
        :additional_driver_signature

      o.collection :rates, nested: true, component: Services::Builders::LineItem

      o.object :deposit, component: Services::Builders::LineItem

      o.attributes :sub_total, :tax_collectable, :total, :combined_tax_rate
    end
  end

  def query
    Rental.includes(:driver, :additional_driver, :vehicle, :pickup_location, :drop_off_location).find_by(number: number)
  end
end
