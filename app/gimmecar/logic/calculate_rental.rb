class Logic::CalculateRental < Lib::Logic::Base

  model :rental

  RATE = 3500

  SALES_TAX = BigDecimal.new(0.0775, 8)

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

    date = rental_period.start_date

    rental_period.days_apart.times do |x|

      #rate = Rate.where(:date => date).rate || RATE
      rate = RATE

      output << {
        :value => rate,
        :date  => date,
      }

      date += 1
    end

    extra_hours = Lib::DateRange.new(date, rental_period.end_date).hours_apart

    if extra_hours > 0
      #rate = Rate.where(:date => rental_period.end_date) || RATE
      rate = RATE

      if extra_hours < 3
        value = (rate / BigDecimal.new(3, 1)).ceil * extra_hours
      else
        value = rate
      end

      output << {
        :value => value,
        :date  => date
      }
    end

    output
  end
end
