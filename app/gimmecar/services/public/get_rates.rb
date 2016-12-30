class Services::Public::GetRates < Lib::Forms::Base
  include Lib::Forms::Actions

  attribute :pickup_date,   :date
  attribute :pickup_time,   :time
  attribute :drop_off_date, :date
  attribute :drop_off_time, :time

  validate :pickup_and_drop_off_present,
    :pickup_is_after_today,
    :valid_drop_off,

  def rental_period
    return unless pickup && drop_off
    return unless pickup.before?(drop_off)
    @rental_period ||= Lib::DateRange.new(pickup, drop_off)
  end

  private

  def pickup
    return unless pickup_date && pickup_time
    @pickup ||= Lib::DateTime.create(pickup_date, pickup_time)
  end

  def drop_off
    return unless drop_off_date && drop_off_time
    @drop_off ||= Lib::DateTime.create(drop_off_date, drop_off_time)
  end

  def pickup_and_drop_off_present
    case
    when pickup_date.nil? && pickup_time.nil?
      errors.add(:pickup, "pickup date and time is required")
      errors.add(:pickup_date, nil)
      errors.add(:pickup_time, nil)
    when pickup_date.nil?
      errors.add(:pickup_date, "pickup date is required")
    when pickup_time.nil?
      errors.add(:pickup_time, "pickup time is required")
    end

    case
    when drop_off_date.nil? && drop_off_time.nil?
      errors.add(:drop_off, "drop off date and time is required")
      errors.add(:drop_off_date, nil)
      errors.add(:drop_off_time, nil)
    when drop_off_date.nil?
      errors.add(:drop_off_date, "drop off date is required")
    when drop_off_time.nil?
      errors.add(:drop_off_time, "drop off time is required")
    end
  end

  def pickup_is_after_today
    return unless pickup

    if pickup.past?
      errors.add(:pickup, "can't be in the past")
      errors.add(:pickup_date, nil)
      errors.add(:pickup_time, nil)
    end
  end

  def valid_drop_off
    return unless pickup && drop_off

    case
    when !pickup.before?(drop_off)
      errors.add(:drop_off, "drop off date must be after pickup date")
      errors.add(:drop_off_date, nil)
      errors.add(:drop_off_time, nil)
    when rental_period.days_apart > 10
      errors.add(:drop_off, "can't book a rental for more than 10 days")
      errors.add(:drop_off_date, nil)
      errors.add(:drop_off_time, nil)
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
