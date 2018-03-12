class Logic::Rates::Weekly < Logic::Rates::Base

  DISCOUNT_WEEKLY = 0.1
  PREMIUM_WEEKEND = 0.25

  def calculate
    discount = 0
    discount += DISCOUNT_WEEKLY
    discount -= PREMIUM_WEEKEND if (start_date.friday? || start_date.saturday?)

    (base_rate * (1 - discount)).round
  end
end
