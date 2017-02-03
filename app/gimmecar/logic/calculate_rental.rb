class Logic::CalculateRental < Lib::Logic::Base

  model :rental

  RATE = 3500

  SALES_TAX = BigDecimal.new(0.08, 1)

  def rates
    @rates ||= calculate_rate
  end

  def tax
    @tax ||= {
      :value => (rates.sum { |r| r.fetch(:value) } * SALES_TAX).ceil,
      :rate  => SALES_TAX,
    }
  end

  def total
    @total ||= rates.sum { |r| r.fetch(:value) } + tax.fetch(:value)
  end

  private

  def calculate_rate
    output = []

    rental_period.days_apart.times do |x|
      date = (rental_period.start_date + x)

      #rate = Rate.where(:date => date).rate || RATE
      rate = RATE

      output << {
        :value => rate,
        :date  => date,
      }
    end

    extra_hours = rental_period.hours_apart % 24

    if extra_hours > 0
      #rate = Rate.where(:date => rental_period.end_date) || RATE
      rate = RATE

      if extra_hours < 3
        value = (rate / BigDecimal.new(3, 1)).ceil * extra_hours
      else
        value = rate
      end

      if rental_period.days_apart == 0
        date = rental_period.start_date
      else
        date = rental_period.end_date
      end

      output << {
        :value => value,
        :date  => date
      }
    end

    output
  end
end
