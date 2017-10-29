class Actions::Public::GetRates < Lib::Forms::Base

  attributes do |a|
    a.integer :location_id
    a.string :vehicle_type
    a.date_time :pickup
    a.date_time :drop_off
  end

  validates :location_id,
    presence: { message: 'must select a location' }

  validates :pickup,
    presence: true,
    after_date: { with: -> { DateTime.now - 59.minutes }, message: 'must be in the future' }

  validates :drop_off,
    presence: true,
    after_date: { with: -> { pickup }, allow_nil: true, message: 'must be after pickup' }

  validates :vehicle_type,
    inclusion: { in: Vehicle::TYPES, message: "must select a valid vehicle type" }

  validate :valid_drop_off

  private

  def valid_drop_off
    return if errors.any?

    if Lib::DateRange.new(pickup, drop_off).days_apart > 29
      errors.add(:drop_off, "can't book a rental for more than 29 days")
    end
  end

  def success_args
    Services::Rates.fetch(rental: self, location: location)
  end

  def location
    @location ||= Location.find(location_id)
  end

  def save
  end
end
