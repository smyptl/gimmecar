module Actions::Admin::Location::Rental::New::Concerns::Vehicle
  extend ActiveSupport::Concern

  included do
    attributes do |a|
      a.date_time :drop_off
      a.string    :vehicle_type
      a.integer   :vehicle_id
      a.integer   :pickup_odometer
      a.integer   :pickup_fuel
    end

    validates :vehicle_type,
      presence: true

    validates :vehicle_id,
      inclusion: { in: :available_vehicle_ids, message: 'Select a vehicle.' }

    validates :pickup_odometer,
      presence: true,
      numericality: { only_integer: true }

    validates :pickup_fuel,
      presence: true,
      inclusion: { in: 0..10 }
  end

  def available_vehicle_ids
    raise NotImplementedError
  end

  def location
    raise NotImplementedError
  end
end
