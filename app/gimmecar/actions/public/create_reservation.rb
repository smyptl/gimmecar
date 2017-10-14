class Actions::Public::CreateReservation < Lib::Forms::Base

  attributes do |a|
    a.integer   :location_id
    a.date_time :pickup
    a.date_time :drop_off
    a.string    :vehicle_type
    a.string    :name_first
    a.string    :name_last
    a.string    :email
    a.integer   :phone_number
  end

  validates :name_first, :name_last,
    presence: true

  validates :email,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "must be a valid email" }

  validates :phone_number,
    length: { is: 10, wrong_length: "must be a valid phone number with area code" }

  def rental_period
    @rental_period ||= Lib::DateRange.new(pickup, drop_off)
  end

  private

  def failure_args
    {
      :errors => errors,
    }
  end

  def success_args
    @success_args ||= {
      :name_first          => name_first,
      :name_last           => name_last,
      :email               => email,
      :vehicle_type        => vehicle_type,
      :phone_number        => phone_number,
      :confirmation_number => confirmation_number,
    }.merge(rates)
  end

  def confirmation_number
    @confirmation_number ||= SecureRandom.hex(3)
  end

  def rates
    @rates ||= Services::Rates.fetch(rental: self, location: Location.find(location_id))
  end

  def save
    Public::RentalConfirmation.customer(success_args).deliver_now
    Public::RentalConfirmation.samay(success_args).deliver_now
  end
end
