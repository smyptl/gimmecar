class Services::Admin::Location::Rentals < Lib::Services::Base

  output do
    collection :rentals, component: Services::Builders::RentalsTable
  end

  def query
    Location.includes(open_rentals: [:vehicle, :driver]).find(params.fetch(:location_id)).open_rentals
  end
end
