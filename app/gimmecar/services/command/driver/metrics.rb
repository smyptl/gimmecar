class Services::Command::Driver::Metrics < Lib::Services::Base

  attributes do |a|
    a.integer :id
  end

  output do
    nested :metrics, logic: Logic::Metrics::Rentals do |n|
      n.attributes :rentals_count,
        :days_paid,
        :sub_total,
        :miles_driven,
        :average_miles_per_day,
        :average_rate,
        :average_price_per_mile
    end
  end

  private

  def query
    Driver.find(id).rentals_closed
  end
end
