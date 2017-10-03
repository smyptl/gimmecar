class Logic::Rates < Lib::Services::Base

  attributes do |a|
    a.default :location
    a.default :rental
  end

  private

  def rental_period
    @rental_period ||= Lib::DateRange.new(rental.pickup, rental.drop_off)
  end

  def rates
  end
end
