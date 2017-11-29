class Logic::Rates::Day < Logic::Rates::Base

  DAILY_PREMIUM     = 0.10
  WEEKEND_PREMIUM   = 0.10

  OFF_HOURS_PREMIUM = 0.05
  OFF_HOURS = [0, 1, 2, 3, 4, 5, 6, 18, 19, 20, 21, 22, 23]

  def calculate
    premium = 0
    premium += DAILY_PREMIUM
    premium += WEEKEND_PREMIUM if (start_date.friday? || start_date.thursday?)
    premium += OFF_HOURS_PREMIUM if (OFF_HOURS.include?(start_date.hour))

    base_rate * (1 + premium)
  end
end
