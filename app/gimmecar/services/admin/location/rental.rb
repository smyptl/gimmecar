class Services::Admin::Location::Rental < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental, component: Services::Builders::Rental do |o|
      o.object :driver,            component: Services::Builders::Driver
      o.object :additional_driver, component: Services::Builders::Driver
      o.object :vehicle,           component: Services::Builders::VehiclesTable
    end
  end

  def query
    Rental.includes(:driver, :additional_driver, :vehicle).find_by(number: number)
  end
end
