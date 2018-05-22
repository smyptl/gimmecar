module Actions::Admin::Location::Rental::New::Concerns::Vehicle
  extend ActiveSupport::Concern

  included do
    attributes do |a|
      a.time    :drop_off
      a.string  :vehicle_type
      a.integer :vehicle_id
      a.integer :pickup_odometer
      a.integer :pickup_fuel
    end

    validates :vehicle_type,
      presence: true

    validates :vehicle_id,
      inclusion: { in: :available_vehicle_ids, message: 'Select a vehicle.' }

    validates :pickup_odometer,
      presence: true

    validates :pickup_odometer,
      numericality: { greater_than_or_equal_to: :latest_odometer, message: "must be greater than %{count}" },
      if: [:latest_odometer, :pickup_odometer]

    validates :pickup_fuel,
      presence: true,
      inclusion: { in: 0..10 }
  end

  private

  def latest_odometer
    if vehicle_id
      vehicle.odometer || 0
    end
  end

  def vehicle
    location.vehicles.find(vehicle_id)
  end

  def available_vehicle_ids
    location.available_vehicle_ids(vehicle_type: vehicle_type)
  end

  def location
    raise NotImplementedError
  end
end
