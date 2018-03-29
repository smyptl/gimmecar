class Services::Command::Vehicle::Rentals < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  output do
    collection :rentals, component: Services::Builders::RentalsTable do |c|
      c.attribute :pickup_location_name
    end
  end

  private

  def query
    Vehicle.includes(rentals: [:driver, :pickup_location]).find_by(vin: vin).rentals.order(pickup: :desc)
  end
end
