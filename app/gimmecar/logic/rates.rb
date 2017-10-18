class Logic::Rates < Lib::Services::Base

  def initialize(pickup:, drop_off:, vehicle_type:, location:, tax_calculator: LineItem)
  end

  private

  def rental_period
    @rental_period ||= Lib::DateRange.new(rental.pickup, rental.drop_off)
  end

  def rates
  end
end
