class Logic::Rates::Daily < Logic::Rates::Base

  DAILY_PREMIUM     = 0.15
  WEEKEND_PREMIUM   = 0.10
  OFF_HOURS_PREMIUM = 0.05
  OFF_HOURS = [18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4, 5, 6]

  def calculate
    premium = 0
    premium += DAILY_PREMIUM if (days_apart <= 2)
    premium += WEEKEND_PREMIUM if (start_date.friday? || start_date.thursday?)
    premium += OFF_HOURS_PREMIUM if (OFF_HOURS.include?(start_date.hour))

    (@base_rate * (1 + premium)).round
  end
end
