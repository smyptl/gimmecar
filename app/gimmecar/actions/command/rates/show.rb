class Actions::Admin::Location::Rates::Show < Lib::Forms::Base

  attributes do |a|
    a.date_time :pickup
    a.date_time :drop_off
    a.string    :vehicle_type
    a.integer   :location_id
  end

  validates :pickup,
    presence: true,
    after_date: { with: -> { DateTime.now - 59.minutes }, message: 'must be in the future' }

  validates :drop_off,
    presence: true,
    after_date: { with: -> { pickup }, allow_nil: true, message: 'must be after pickup' }

  validates :vehicle_type,
    presence: true

  validates :location_id,
    inclusion: { in: -> (r) { Location.exists?(r.location_id) }, message: 'must select a valid location' }

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
