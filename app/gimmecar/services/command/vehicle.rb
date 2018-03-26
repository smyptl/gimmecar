class Services::Command::Vehicle < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  output do
    object :vehicle, component: Services::Builders::Vehicle
  end

  private

  def query
    Vehicle.includes(:location, rentals: [:driver, :pickup_location]).find_by(vin: vin)
  end
end
