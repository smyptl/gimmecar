class Services::Command::Rental < Lib::Services::Base

  attributes do |a|
    a.string :number
  end

  output do
    object :rental, component: Services::Builder::Rental
  end

  private

  def query
    Rental.includes(:vehicle, :pickup_location, :drop_off_location, :driver, :additional_driver).find_by(number: number)
  end
end
