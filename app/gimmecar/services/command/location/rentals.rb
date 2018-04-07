class Services::Command::Location::Rentals < Lib::Services::Base

  attributes do |a|
    a.string :slug
  end

  output do
    collection :rentals, component: Services::Builders::RentalsTable
  end

  def query
    Location.find_by(slug: slug).rentals_open
  end
end
