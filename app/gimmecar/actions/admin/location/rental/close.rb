class Actions::Admin::Location::Rental::Close < Lib::Forms::Base

  attr_reader :rental

  attributes do |a|
    a.date_time :drop_off
    a.integer :drop_off_odometer
    a.integer :drop_off_fuel
  end

  validates :drop_off,
    presence: true

  validates :drop_off_odometer,
    presence: true

  validates :drop_off_fuel,
    presence: true

  def save
    @rental = Rental.find_by(number: @params.fetch('rental_id'))
    @rental.close(attributes)

    @rental.vehicle.update(status: 'dirty')
  end

  def success_args
    {
      rental_number: rental.number,
    }
  end
end
