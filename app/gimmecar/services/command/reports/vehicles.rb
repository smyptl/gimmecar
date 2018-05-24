class Services::Command::Reports::Vehicles < Lib::Services::Base

  output do
    collection :vehicles, component: Services::Builders::VehiclesTable do |c|
      c.attributes :fuel_level, :odometer, :date_commissioned, :date_decommissioned, :purchase_price
      c.attribute :revenue, output: -> (v) { Logic::Metrics::Rentals.new(v.rentals).rental_rates_sub_total }
    end
  end

  def query
    ::Vehicle.includes(:rental_open, rentals: [:rental_rates]).order(created_at: :asc).all
  end
end
