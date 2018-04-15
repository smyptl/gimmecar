class Logic::Metrics::Rental < SimpleDelegator
  include Lib::Wrap

  def latest_odometer
    drop_off_odometer || pickup_odometer
  end

  def miles_driven
    drop_off_odometer - pickup_odometer if closed?
  end

  def days_paid
    rental_rates.count
  end

  def average_miles_per_day
    miles_driven/days_paid if miles_driven
  end

  def rental_rates_sub_total
    rental_rates.sum(&:sub_total)
  end

  def average_rate
    sub_total/days_paid if days_paid > 0
  end

  def average_price_per_mile
    sub_total/miles_driven if miles_driven
  end
end
