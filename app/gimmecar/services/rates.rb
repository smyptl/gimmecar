class Services::Rates < Lib::Services::Base

  attributes do |a|
    a.value :location
    a.value :rental
  end

  private

  def output
    {
      :vehicle           => { make_model: ActiveSupport::Inflector.titleize(rental.vehicle_type) },
      :location          => { description: location.description },
      :pickup            => rental.pickup,
      :drop_off          => rental.drop_off,
      :rates             => rates,
      :deposit           => deposit,
      :add_ons           => add_ons,
      :discount          => discount,
      :sub_total         => sub_total,
      :combined_tax_rate => combined_tax_rate,
      :tax_collectable   => tax_collectable,
      :total             => total,
    }
  end

  def rental_period
    @rental_period ||= Lib::DateRange.new(rental.pickup, rental.drop_off)
  end

  def rates
    @rates ||= calculate_rate
  end

  def deposit
    @deposit ||= LineItem.calculate(amount: Rental::DEPOSIT_AMOUNT, taxable_amount: 0, date: nil, tax_rate: tax_rate)
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

  def tax_rate
    @tax_rate ||= location.latest_tax_rate
  end

  def calculate_rate
    Logic::Rates::Base.new(rental_period: rental_period, location: location, base_rate: rate, tax_rate: tax_rate).retrieve
  end

  def rate
    location.rate_for(rental.vehicle_type).amount
  end
end
