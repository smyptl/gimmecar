class Services::Command::Vehicle < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  output do
    object :vehicle, component: Services::Builders::Vehicle do |o|
      o.attributes :fuel_level, :odometer
    end
  end

  private

  def query
    Vehicle.includes(:location, :latest_rental).find_by(vin: vin)
  end
end
