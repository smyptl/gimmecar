class Logic::Rates::Daily < Logic::Rates::Base

  DAILY_PREMIUM      = 0.15
  WEEKEND_PREMIUM    = 0.10
  OFF_HOURS_PREMIUM  = 0.075
  OFF_HOURS_WEEKDAY  = [18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4, 5, 6]
  OFF_HOURS_SATURDAY = [15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4, 5, 6, 7]
  OFF_HOURS_SUNDAY   = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4, 5, 6, 7]

  def calculate
    premium = 0
    premium += DAILY_PREMIUM     if (days_apart <= 2)
    premium += WEEKEND_PREMIUM   if (start_date.friday? || start_date.thursday?)
    premium += OFF_HOURS_PREMIUM if off_hour?(start_date)

    (@base_rate * (1 + premium)).round
  end

  private

  def off_hour?(date)
    off_hours = case
                when date.saturday?
                  OFF_HOURS_SATURDAY
                when date.sunday?
                  OFF_HOURS_SUNDAY
                else
                  OFF_HOURS_WEEKDAY
                end

    off_hours.include?(date.hour)
  end
end
