class Services::Admin::Location::Vehicles::Available < Lib::Services::Base

  attributes do |a|
    a.integer :location_id
    a.string  :vehicle_type
  end

  output do
    collection :vehicles, component: Services::Builders::VehiclesTable do |c|
      c.attribute :color
    end
  end

  private

  def query
    Location.find(location_id).available_vehicles(vehicle_type: vehicle_type)
  end
end
