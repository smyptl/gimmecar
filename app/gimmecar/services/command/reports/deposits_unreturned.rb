class Services::Command::Reports::DepositsUnreturned < Lib::Services::Base

  output do
    collection :rentals, component: Services::Builders::RentalsTable do |c|
      c.attribute :pickup_location_name
    end
  end

  private

  def query
    LineItem.includes(invoice: [:pickup_location, :driver, :vehicle]).deposits_unreturned.map(&:invoice)
  end
end
