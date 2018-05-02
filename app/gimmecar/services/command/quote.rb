class Services::Command::Quote < Lib::Services::Base

  attributes do |a|
    a.integer :location_id
    a.time    :pickup
    a.time    :drop_off
    a.string  :vehicle_type
  end

  validates :pickup,
    presence: true,
    after_date: { with: -> { Time.current - 59.minutes }, message: 'must be in the future' }

  validates :drop_off,
    presence: true,
    after_date: { with: -> { pickup }, allow_nil: true, message: 'must be after pickup' }

  validates :vehicle_type,
    presence: true

  validates :location_id,
    presence: true

  validate :valid_drop_off

  private

  def valid_drop_off
    return if errors.any?

    if Lib::DateRange.new(pickup, drop_off).days_apart > Rental::LIMIT
      errors.add(:drop_off, "can't book a rental for more than #{Rental::LIMIT} days")
    end
  end

  def output
    Services::Rates.new(rental: self, location: location).retrieve!
  end

  def location
    @location ||= ::Location.find(location_id)
  end
end
