class Services::Admin::Rental::Rates < Lib::Forms::Base
  include Lib::Forms::Actions

  attributes do |a|
    a.date_time :pickup
    a.date_time :drop_off
  end

  validates :pickup,
    presence: true,
    after_date: { with: -> { DateTime.now - 30.minutes }, message: 'must be in the future' }

  validates :drop_off,
    presence: true,
    after_date: { with: -> { pickup }, allow_nil: true, message: 'must be after pickup' }

  validate :valid_drop_off

  def rental_period
    return unless pickup && drop_off
    return unless pickup.before?(drop_off)
    @rental_period ||= Lib::DateRange.new(pickup, drop_off)
  end

  private

  def valid_drop_off
    return unless pickup && drop_off
    return unless pickup.before?(drop_off)

    if rental_period.days_apart > 10
      errors.add(:drop_off, "can't book a rental for more than 10 days")
    end
  end

  def failure_args
    {
      :errors => errors,
    }
  end

  def success_args
    {
      :vehicle  => "Toyota Corolla",
      :location => "Super 8 Redlands - 1160 Arizona St. Redlands, CA 92374",
      :pickup   => pickup,
      :drop_off => drop_off,
      :rates    => calculate_rental.rates,
      :tax      => calculate_rental.tax,
      :total    => calculate_rental.total
    }
  end

  def calculate_rental
    @calculate_rental ||= Logic::CalculateRental.new(self)
  end

  def save
  end
end
