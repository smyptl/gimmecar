class Logic::Rates::Daily < Logic::Rates::Base

  PREMIUM_SHORT      = 0.175
  PREMIUM_DAILY      = 0.14
  PREMIUM_WEEKEND    = 0.125
  PREMIUM_OFF_HOURS  = 0.080

  OFF_HOURS_WEEKDAY  =                 [17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4, 5, 6, 7]
  OFF_HOURS_SATURDAY =         [15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4, 5, 6, 7]
  OFF_HOURS_SUNDAY   = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4, 5, 6, 7]

  def calculate
    premium = 0
    premium += PREMIUM_SHORT     if (hours_apart <= 50)
    premium += PREMIUM_DAILY     if (hours_apart <= 98)
    premium += PREMIUM_WEEKEND   if (start_date.saturday? || start_date.friday? || start_date.thursday?)
    premium += PREMIUM_OFF_HOURS if off_hour?

    (base_rate * (1 + premium)).round
  end

  private

  def off_hour?
    case
    when start_date.saturday?
      OFF_HOURS_SATURDAY
    when start_date.sunday?
      OFF_HOURS_SUNDAY
    else
      OFF_HOURS_WEEKDAY
    end.include?(start_date.hour)
  end
end
