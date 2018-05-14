class Services::Command::Reports::RevenueMonthly < Lib::Services::Base

  private

  def output
    LineItem.rental_rates.group_by_month(:date, format: '%b %Y').sum(:sub_total)
  end
end
