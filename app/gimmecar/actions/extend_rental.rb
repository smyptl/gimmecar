class Actions::ExtendRental

  def initialize(rental:, date:, days:, amount:)
    @rental, @date, @days, @amount = rental, date, days, amount
  end

  def execute
    total = LineItem.calculate(amount: @amount, date: nil, tax_rate: @rental.tax_rate).fetch(:total)*@days

    success = lambda do |args|
      c = args[:charge]
      c.owner = @rental
      c.save

      d = @date

      @days.times do
        li = LineItem.new(LineItem.calculate(amount: @amount, date: d, tax_rate: @rental.tax_rate).to_h)
        li.charge = c
        li.invoice = @rental
        li.item_type = 'rental_rate'
        li.save
        d += 1.day
      end

      @rental.drop_off += @days.days
      @rental.save
    end

    failure = lambda do |args|
      puts args[:message]
    end

    Charge.new(amount: total).execute(success, failure, customer_id: @rental.driver.stripe_id)
  end
end
