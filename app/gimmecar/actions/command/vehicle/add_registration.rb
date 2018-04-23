class Actions::Command::Vehicle::AddRegistration < Lib::Actions::Base

  attributes do |a|
    a.date     :date_effective
    a.date     :date_expiration
    a.document :registration
  end

  validates :date_effective, :registration,
    presence: true

  validates :date_expiration,
    presence: true,
    after_date: -> { date_effective }

  private

  def success_args
    {
      message: 'Registration added.'
    }
  end

  def save
    vehicle_registration = VehicleRegistration.create({
      vehicle_id:      vehicle,
      date_effective:  date_effective,
      date_expiration: date_expiration,
    })

    vehicle_registration.document.attach(:registration)
  end

  def vehicle
    Vehicle.find_by(vin: params.fetch(:vin))
  end
end
