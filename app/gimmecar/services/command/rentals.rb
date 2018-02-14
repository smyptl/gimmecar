class Services::Command::Rentals < Lib::Services::Base

  output do
    collection :rental do |c|
      c.component Services::Builders::RentalsTable
      c.value :pickup_location_name
    end
  end

  def query
    ::Rental.includes(:pickup_location, :vehicle, :driver).open
  end
end
