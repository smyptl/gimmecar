class Actions::Admin::Location::Rental::GetRates < Lib::Forms::Base

  attributes do |a|
    a.date_time :pickup
    a.date_time :drop_off
  end

  validates :pickup,
    presence: true,
    after_date: { with: -> { DateTime.now - 59.minutes }, message: 'must be in the future' }

  validates :drop_off,
    presence: true,
    after_date: { with: -> { pickup }, allow_nil: true, message: 'must be after pickup' }

  validate :valid_drop_off

  def vehicle_type
    :compact
  end

  private

  def valid_drop_off
    return if errors.any?

    if Lib::DateRange.new(pickup, drop_off).days_apart > 10
      errors.add(:drop_off, "can't book a rental for more than 10 days")
    end
  end

  def success_args
    Services::Rates.fetch(rental: self, location: params[:location])
  end

  def save
  end
end
