class Logic::CalculateRental < Lib::Logic::Base

  model :rental

  RATE = 4400

  SALES_TAX = BigDecimal.new(0.08, 8)

  def fetch
    {
      :vehicle    => "Toyota Corolla",
      :location   => "Super 8 Redlands - 1160 Arizona St. Redlands, CA 92374",
      :pickup     => pickup,
      :drop_off   => drop_off,
      :line_items => line_items,
      :total      => total,
    }
  end

  def line_items
    rates
  end

  def rates
    @rates ||= calculate_rate
  end

  def sub_total
    @sub_total ||= line_items.sum { |r| r.fetch(:amount) }
  end

  def tax
    @tax = line_items.sum { |r| r.fetch(:tax) }
  end

  def total
    @total ||= sub_total + tax
  end

  private

  def calculate_rate
    output = []

    date = rental_period.start_date

    rental_period.days_apart.times do |x|

      #rate = Rate.where(:date => date).rate || RATE
      rate = RATE

      output << {
        :item_type => :rate,
        :details   => { :date => date },
        :amount    => rate,
        :tax_rate  => SALES_TAX,
        :tax       => (rate * SALES_TAX).ceil
      }

      date += 1
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
        :item_type => :rate,
        :details   => { :date => date },
        :amount    => value,
        :tax_rate  => SALES_TAX,
        :tax       => (value * SALES_TAX).ceil
      }
    end

    output
  end
end
