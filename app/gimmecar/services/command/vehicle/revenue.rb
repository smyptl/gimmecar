class Services::Command::Vehicle::Revenue < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  private

  def output
    query
  end

  def query
    Vehicle.includes(:rental_rates).find_by(vin: vin).rental_rates.group_by_month(:date, format: '%b %Y').sum(:sub_total)
  end
end
