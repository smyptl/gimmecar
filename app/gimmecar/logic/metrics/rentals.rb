class Logic::Metrics::Rentals < SimpleDelegator

  def average_per_month
    group_by_month(:date, format: '%b %Y').average(:sub_total)
  end

  def rentals_count
    rentals.count
  end

  def sub_total
    rentals.sum(&:sub_total)
  end

  def miles_driven
    rentals.sum(&:miles_driven)
  end

  def days_paid
    rentals.sum(&:days_paid)
  end

  def average_miles_per_day
    miles_driven/days_paid if days_paid > 0
  end

  def average_rate
    sub_total/days_paid if days_paid > 0
  end

  def average_price_per_mile
    sub_total/miles_driven if miles_driven > 0
  end

  private

  def rentals
    @rentals ||= Logic::Metrics::Rental.wrap(__getobj__)
  end
end
