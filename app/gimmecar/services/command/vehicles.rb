class Services::Command::Vehicles < Lib::Services::Base

  output do
    collection :vehicles do |c|
      c.component Services::Builders::VehiclesTable
      c.attribute :location_name
    end
  end

  private

  def query
    ::Vehicle.includes(:location).order(created_at: :asc).all
  end
end
