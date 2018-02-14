class Services::Admin::Vehicles::Available < Lib::Services::Base

  attributes do |a|
    a.integer :location_id
    a.string :vehicle_type
  end

  output do
    collection :vehicles, component: Services::Builders::VehicleTable
  end

  private

  def query
    Location.find(location_id).available_vehicles(vehicle_type: vehicle_type)
  end
end
