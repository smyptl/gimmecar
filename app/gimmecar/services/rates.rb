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
    Logic::Rates::Base.new(rental_period: rental_period, location: location, base_rate: rate, tax_rate: location.latest_tax_rate).fetch
  end

  def rate
    location.rate_for(rental.vehicle_type).amount
  end
end
