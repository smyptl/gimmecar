class Actions::Admin::Location::Rental::Close < Lib::Actions::Base

  attributes do |a|
    a.time    :drop_off
    a.integer :drop_off_odometer
    a.integer :drop_off_fuel
  end

  validates :drop_off,
    presence: true,
    after_date: { with: -> { pickup }, message: 'must be after pickup' }

  validates :drop_off_odometer,
    presence: true,
    numericality: { greater_than: :pickup_odometer, message: 'must be greater than pickup odometer' }

  validates :drop_off_fuel,
    presence: true

  validate :can_close

  private

  def save
    rental.close(attributes)
    rental.vehicle.update_status_dirty
  end

  def can_close
    unless rental.can_close?
      errors.add(:base, 'cannot close rental')
    end
  end

  def rental
    @rental ||= Rental.find_by(number: params.fetch(:number))
  end
  delegate :pickup, :pickup_odometer, to: :rental

  def success_args
    {
      number: rental.number,
    }
  end
end
