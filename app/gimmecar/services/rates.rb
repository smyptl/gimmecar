class Services::Rates < Lib::Services::Base

  attributes do |a|
    a.default :location
    a.default :rental
  end

  def fetch
    {
      :vehicle           => ActiveSupport::Inflector.titleize(rental.vehicle_type),
      :location          => location.description,
      :pickup            => rental.pickup,
      :drop_off          => rental.drop_off,
      :rates             => rates,
      :add_ons           => add_ons,
      :discount          => discount,
      :sub_total         => sub_total,
      :combined_tax_rate => combined_tax_rate,
      :tax_collectable   => tax_collectable,
      :total             => total,
    }
  end

  private

  def rental_period
    @rental_period ||= Lib::DateRange.new(rental.pickup, rental.drop_off)
  end

  def rates
    @rates ||= calculate_rate
  end

  def add_ons
    []
  end

  def discount
    nil
  end

  def combined_tax_rate
    location.latest_combined_tax_rate
  end

  def sub_total
    (rates + add_ons).sum { |l| l.fetch('sub_total') }
  end

  def tax_collectable
    line_items.sum { |l| l.fetch('tax_collectable') }
  end

  def total
    line_items.sum { |l| l.fetch('total') }
  end

  def line_items
    rates + add_ons
  end

  def calculate_rate
    output = []

    date = rental_period.start_date

    rental_period.days_apart.times do |x|
      rate = rate(date)

      output << build_rate(rate: rate, amount: rate, date: date)
      date += 1.day
    end

    extra_hours = rental_period.hours_apart % 24

    if extra_hours > 0
      rate = rate(date)

      if extra_hours < 3
        amount = ((rate / BigDecimal.new(3, 1)) * extra_hours).ceil
      else
        amount = rate
      end

      output << build_rate(rate: rate, amount: amount, date: date)
    end

    output
  end

  def build_rate(rate:, amount:, date:, discount: 0)
    LineItem.calculate(date: date, amount: amount, discount: discount, tax_rate: location.latest_tax_rate).merge(rate: rate)
  end

  def rate(date)
    location.rates_for(vehicle_type: rental.vehicle_type, date: date).amount
  end
end
