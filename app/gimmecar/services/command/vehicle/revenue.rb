class Services::Command::Vehicle::Revenue < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  private

  def output
    query
  end

  def query
    Vehicle.includes(:rates).find_by(vin: vin).rates.group_by_month(:date, format: '%b %Y').sum(:sub_total)
  end
end
