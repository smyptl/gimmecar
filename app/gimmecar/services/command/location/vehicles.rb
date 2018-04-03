class Services::Command::Location::Vehicles < Lib::Services::Base

  attributes do |a|
    a.string :slug
  end

  output do
    collection :vehicles, component: Services::Builders::VehiclesTable
  end

  private

  def query
    ::Location.includes(:vehicles).find_by(slug: slug).vehicles
  end
end
