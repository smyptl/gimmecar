class Services::Command::Driver::Rentals < Lib::Services::Base

  attributes do |a|
    a.integer :id
  end

  output do
    collection :rentals, component: Services::Builders::RentalsTable do |c|
      c.attribute :pickup_location_name
    end
  end

  private

  def query
    Driver.find(id).rentals.order(pickup: :desc)
  end
end
