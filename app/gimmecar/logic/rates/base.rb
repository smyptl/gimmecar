class Logic::Rates::Base

  def initialize(rental_period:, location:, base_rate:, tax_rate:)
    @rental_period = rental_period
    @location      = location
    @base_rate     = base_rate
    @tax_rate      = tax_rate
  end

  def fetch
    days_apart = rental_period.days_apart

    klass = case
            when days_apart >= 21
              base_rate*(0.75).round
            when days_apart >= 6
              base_rate*(0.9).round
            when days_apart <= 3
              Logic::Rates::Day
            else
              base_rate
            end

    klass.new(rental_period: @rental_period, location: @location, base_rate: @base_rate).fetch
  end

  private

  def start_date
    @start_date ||= location.convert_date_time_to_time_zone(rental_period.start_date)
  end
end
