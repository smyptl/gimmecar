class Logic::CalculateRental < Lib::Logic::Base

  model :rental

  RATE = 3500

  SALES_TAX = BigDecimal.new(0.08, 1)

  def rates
    @rates ||= calculate_rate
  end

  def tax
    @tax ||= (rates.sum { |r| r.fetch(:value) } * SALES_TAX).ceil
  end

  def total
    @total ||= rates.sum { |r| r.fetch(:value) } + tax
  end

  private

  def calculate_rate
    output = []

    rental_period.days_apart.times do |x|
      date = (rental_period.start_date + x).to_date

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

      output << {
        :value => value,
        :date  => rental_period.end_date.to_date
      }
    end

    output
  end
end
