class Services::Admin::Location::Rentals < Lib::Services::Base

  output do
    collection :rentals, component: Services::Builders::RentalsTable
  end

  def query
    Location.find(params.fetch(:location_id)).rentals_open
  end
end
