class Actions::ExtendRental

  def initialize(rental:, days:, amount:)
    @rental, @days, @amount = rental, days, amount
  end

  def execute
    total = LineItem.calculate(amount: @amount, date: nil, tax_rate: @rental.tax_rate)['total']*@days

    success = lambda do |args|

    end

    Charge.new(amount: total).execute(success, failure, customer_id: @rental.driver.stripe_id)
  end
end
