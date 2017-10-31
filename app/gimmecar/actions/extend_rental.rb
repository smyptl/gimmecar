class Actions::ExtendRental

  def initialize(rental:, date:, days:, amount:)
    @rental, @date, @days, @amount = rental, date, days, amount
  end

  def execute
    total = LineItem.calculate(amount: @amount, date: nil, tax_rate: @rental.tax_rate)['total']*@days

    success = lambda do |args|
      c = args[:charge]
      c.owner = @rental
      c.save

      d = @date

      @days.each do
        li = LineItem.calculate(amount: @amount, date: d, tax_rate: @rental.tax_rate)
        li = LineItem.new(li)
        li.charge = c
        li.invoice = @rental
        li.item = RentalRate.create(amount: @amount, date: d, rental: @rental)
        li.save
        d += 1.day
      end

      @rental.drop_off += @days.days
      @rental.save

      puts 'complete'
    end

    failure = lambda do |args|
      puts args[:message]
    end

    Charge.new(amount: total).execute(success, failure, customer_id: @rental.driver.stripe_id)
  end
end
