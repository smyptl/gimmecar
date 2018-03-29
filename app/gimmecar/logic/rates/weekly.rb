class Logic::Rates::Weekly < Logic::Rates::Base

  DISCOUNT_WEEKLY = 0.04
  PREMIUM_WEEKEND = 0.025

  def calculate
    discount = 0
    discount += DISCOUNT_WEEKLY
    discount -= PREMIUM_WEEKEND if (start_date.thursday? || start_date.friday? || start_date.saturday?)

    (base_rate * (1 - discount)).round
  end
end
