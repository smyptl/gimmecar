class Logic::Metrics::Driver < SimpleDelegator

  def rentals_closed_count
    rentals_closed.count
  end

  def sub_total
    rentals_closed.sum(&:sub_total)
  end

  def miles_driven
    rentals_closed.sum(&:miles_driven)
  end

  def days_paid
    rentals_closed.sum(&:days_paid)
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

  def rentals_closed
    @rentals_closed ||= Lib::Metrics::Rental.wrap(__getobj__.rentals_closed)
  end
end
