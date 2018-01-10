class Logic::Rates::Weekly < Logic::Rates::Base

  WEEKLY_DISCOUNT = 0.10

  def calculate
    discount = WEEKLY_DISCOUNT

    (base_rate * (1 - discount)).round
  end
end
