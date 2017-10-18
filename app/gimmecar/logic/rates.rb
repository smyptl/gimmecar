class Logic::Rates

  attr_reader :rental_period, :vehicle_type, :location

  def initialize(pickup:, drop_off:, vehicle_type:, location:, tax_calculator: LineItem)
    @rental_period  = Lib::DateRange.new(pickup, drop_off)
    @vehicle_type   = vehicle_type
    @location       = location
    @tax_calculator = tax_calculator
  end

  def fetch
  end

  private

  def rates
  end
end
