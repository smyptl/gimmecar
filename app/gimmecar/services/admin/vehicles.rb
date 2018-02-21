class Services::Admin::Vehicles < Lib::Services::Base

  output do
    collection :vehicles, component: Services::Builders::VehiclesTable
  end

  private

  def query
    Location.includes(:vehicles).find(params.fetch(:location_id)).vehicles
  end
end
