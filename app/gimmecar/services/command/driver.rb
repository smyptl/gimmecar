class Services::Command::Driver < Lib::Services::Base

  attributes do |a|
    a.integer :id
  end

  output do
    object :driver, component: Services::Builders::Driver do |o|
      o.attributes :days_rented, :sub_total, :miles_driven, :average_miles_per_day, :average_rate, :average_price_per_mile
    end
  end

  private

  def query
    ::Driver.find(id)
  end
end
