class Actions::GetRates < Lib::Forms::Base

  attribute :pickup,   :date_time
  attribute :drop_off, :date_time

  validates :pickup,
    presence: true

  validates :drop_off,
    presence: true

  validate :pickup_is_after_today,
    :drop_off_is_after_pickup,
    :rental_cannot_be_greater_than_ten_days

  def rental_period
    @rental_period ||= Lib::DateRange.new(pickup, drop_off)
  end

  private

  def pickup_is_after_today
    return unless pickup

    if pickup && pickup.before?(DateTime.now)
      errors.add(:pickup, "can't be in the past")
    end
  end

  def drop_off_is_after_pickup
    return unless pickup && drop_off

    if drop_off.before?(pickup)
      errors.add(:drop_off, "can't drop off vehicle before pickup")
    end
  end

  def rental_cannot_be_greater_than_ten_days
    if rental_period.days_apart > 10
      errors.add(:base, "can't book a rental for more than 10 days")
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
    }
  end

  def save
  end
end
