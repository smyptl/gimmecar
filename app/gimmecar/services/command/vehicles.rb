class Services::Command::Vehicles < Lib::Services::Base

  output do
    collection :vehicles do |c|
      c.component Services::Builders::VehicleTable
      c.value :location_name
    end
  end

  private

  def query
    Vehicle.includes(:pickup_location).all
  end
end
