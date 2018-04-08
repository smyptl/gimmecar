class Logic::Metrics::Rentals::Rates < SimpleDelegator

  def average_per_month
    group_by_month(:date, format: '%b %Y').average(:sub_total)
  end
end
