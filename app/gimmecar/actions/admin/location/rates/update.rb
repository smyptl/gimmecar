class Actions::Admin::Location::Rates::Update < Lib::Forms::Base

  attr_reader :location

  attributes do |a|
    a.integer :amount
    a.string :vehicle_type
  end

  validates :amount,
    presence: true

  validates :vehicle_type,
    inclusion: { in: Vehicle::TYPES, message: 'not valid vehicle type' }

  private

  def save
    rate = (location.find_rate_by(vehicle_type: vehicle_type, date: date) || Rate.new(location: location, date: date, vehicle_type: vehicle_type))
    rate.amount = amount
    rate.save
  end

  def success_args
  end

  def location
    params[:location]
  end
end
