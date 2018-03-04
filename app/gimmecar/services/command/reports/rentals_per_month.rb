class Services::Command::Reports::RentalsPerMonth < Lib::Services::Base

  private

  def output
    {
      labels: query.keys,
      datasets: [
        {
          title: 'Rentals',
          values: query.values,
        },
      ],
    }
  end

  def query
    @query ||= Rental.group_by_month(:pickup, range: date_range, time_zone: "Pacific Time (US & Canada)").count
  end

  def date_range
    current_month = Date.today.beginning_of_month

    (current_month - 12.months)..current_month
  end
end
