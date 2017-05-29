class Logic::CalculateRental < Lib::Logic::Base

  model :rental

  RATE = 3500

  def fetch
    {
      :vehicle         => "Toyota Corolla",
      :location        => rental.pickup_location_description,
      :pickup          => pickup,
      :drop_off        => drop_off,
      :line_items      => line_items,
      :sub_total       => sub_total,
      :combined_tax_rate => combined_tax_rate,
      :tax_collectable => tax_collectable,
      :total           => total,
    }
  end

  def line_items
    @rates ||= calculate_rate
  end

  def combined_tax_rate
    rental.latest_tax_rate.combined_tax_rate
  end

  def sub_total
    line_items.sum(&:amount)
  end

  def tax_collectable
    line_items.sum(&:tax_collectable)
  end

  def total
    line_items.sum(&:total)
  end

  private

  def calculate_rate
    output = []

    date = rental_period.start_date

    rental_period.days_apart.times do |x|

      #rate = Rate.where(:date => date).rate || RATE
      rate = RATE

      output << build_line_item(amount: rate, date: date)

      date += 1.day
    end

    extra_hours = rental_period.hours_apart % 24

    if extra_hours > 0
      #rate = Rate.where(:date => rental_period.end_date) || RATE
      rate = RATE

      if extra_hours < 3
        rate = ((rate / BigDecimal.new(3, 1)) * extra_hours).ceil
      end

      output << build_line_item(amount: rate, date: date)
    end

    output
  end

  def build_line_item(amount: amount, date: date)
    rental.calculate_tax(LineItem.build_readonly({
      :item_type      => :rate,
      :date           => date,
      :amount         => amount,
      :taxable_amount => amount,
    }))
  end
end
