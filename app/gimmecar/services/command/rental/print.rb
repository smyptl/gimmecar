class Services::Command::Rental::Print < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental, component: Services::Builders::RentalPrint
  end

  def query
    Rental.includes(:driver, :additional_driver, :vehicle, :pickup_location, :drop_off_location).find_by(number: number)
  end
end
