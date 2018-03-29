class Logic::Rates::Monthly < Logic::Rates::Base

  MONTHLY_DISCOUNT = 0.12

  def calculate
    discount = MONTHLY_DISCOUNT

    (base_rate * (1 - discount)).round
  end
end
