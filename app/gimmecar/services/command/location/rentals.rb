class Services::Command::Location::Rentals < Lib::Services::Base

  attributes do |a|
    a.string :slug
  end

  output do
    collection :rentals, component: Services::Builders::RentalsTable
  end

  def query
    Location.includes(open_rentals: [:vehicle, :driver]).find_by(slug: slug).open_rentals
  end
end
