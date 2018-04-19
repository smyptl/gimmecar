class Action::Command::Vehicle::AddRegistration < Lib::Actions::Base

  attributes do |a|
    a.date :date_effective
    a.date :date_expiration
    #a.document :registration
    a.text :notes
  end

  validates :date_effective,
    presence: true

  validates :date_expiration,
    presence: true,
    after_date: -> { date_effective }

  private

  def save
    vehicle_registration = VehicleRegistration.create({
      vehicle_id:      vehicle,
      date_effective:  date_effective,
      date_expiration: date_expiration,
      notes:           notes
    })

    vehicle_registration.document.attach(:registration)
  end
end
