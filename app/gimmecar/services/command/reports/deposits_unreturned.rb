class Services::Command::Reports::DepositsUnreturned < Lib::Services::Base

  output do
    collection :rentals, component: Services::Builders::RentalsTable
  end

  private

  def query
    LineItem.includes(invoice: [:pickup_location, :driver, :vehicle]).deposits_unreturned.map(&:invoice)
  end
end
