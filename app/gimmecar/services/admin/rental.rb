class Services::Admin::Rental < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental, component: Services::Builders::Rental
  end

  def query
    Rental.includes(:driver, :additional_driver, :vehicle).find_by(number: number)
  end
end
