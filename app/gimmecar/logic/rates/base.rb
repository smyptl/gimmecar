class Logic::Rates::Base

  attr_reader :rental_period, :location, :base_rate, :tax_rate

  def initialize(rental_period:, location:, base_rate:, tax_rate:)
    @rental_period = rental_period
    @location      = location
    @base_rate     = base_rate
    @tax_rate      = tax_rate
  end

  def retrieve
    output = []

    date = start_date
    rate = calculate

    days_apart.times do |x|
      output << build_rate(amount: rate, date: date)
      date += 1.day
    end

    extra_hours = rental_period.hours_apart % 24

    if output.empty? || (2..23).include?(extra_hours)
      output << build_rate(amount: rate, date: date)
    end

    output
  end

  def calculate
    klass = case
            when days_apart >= 21
              Logic::Rates::Monthly
            when days_apart >= 6
              Logic::Rates::Weekly
            else
              Logic::Rates::Daily
            end

    klass.new(rental_period: rental_period, location: location, base_rate: base_rate, tax_rate: tax_rate).calculate
  end

  private

  def days_apart
    @days_apart ||= rental_period.days_apart
  end

  def hours_apart
    @hours_apart ||= rental_period.hours_apart
  end

  def start_date
    @start_date ||= location.convert_date_time_to_time_zone(rental_period.start_date)
  end

  def build_rate(amount:, date:, discount: 0)
    LineItem.calculate(date: date, amount: amount, discount: discount, tax_rate: tax_rate)
  end
end
