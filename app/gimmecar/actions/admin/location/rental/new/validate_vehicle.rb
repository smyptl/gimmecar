class Actions::Admin::Location::Rental::New::ValidateVehicle < Lib::Forms::Base

  attributes do |a|
    a.integer :vehicle_type
    a.integer :vehicle_id
    a.integer :pickup_odometer
    a.integer :pickup_fuel
  end

  validates :vehicle_type,
    presence: true

  validates :vehicle_id,
    inclusion: { in: :available_vehicle_ids, message: 'select a vehicle' }

  validates :pickup_odometer,
    presence: true,
    numericality: { only_integer: true }

  validates :pickup_fuel,
    presence: true,
    inclusion: { in: 0..10 }

  def save
  end

  def success_args
  end
end
