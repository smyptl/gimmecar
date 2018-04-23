class Services::Command::Vehicle::Registrations < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  output do
    collection :registrations do |c|
      c.attributes :date_effective, :date_expiration
    end
  end

  private

  def query
    Vehicle.includes(rentals: [:driver, :pickup_location]).find_by(vin: vin).rentals.order(pickup: :desc)
  end
end
