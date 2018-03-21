class Actions::ExtendRental

  def initialize(rental:, date:, days:, amount:)
    @rental, @date, @days, @amount = rental, date, days, amount
  end

  def execute
    Charge.new(amount: total).execute(success, failure, customer_id: @rental.stripe_customer_id)
  end

  private

  def total
    @total ||= line_item_calculations.fetch(:total)*@days
  end

  def line_item_calculations
    @line_item ||= LineItem.calculate(amount: @amount, date: nil, tax_rate: @rental.tax_rate)
  end

  def success
    lambda do |args|
      charge = args[:charge]
      charge.owner = @rental
      charge.save

      date = @date

      @days.times do
        li = LineItem.new(line_item_calculations.merge(date: date))
        li.charge = charge
        li.invoice = @rental
        li.item_type = 'rental_rate'
        li.save
        date += 1.day
      end

      @rental.drop_off += @days.days
      @rental.save

      puts "Rental #{@rental.number} extended by #{@days} days, #{charge.amount} charged."
    end
  end

  def failure
    lambda do |args|
      puts args[:message]
    end
  end
end
