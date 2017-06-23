class Actions::Public::CreateReservation < Lib::Forms::Base

  attributes do |a|
    a.date_time :pickup
    a.date_time :drop_off
    a.string    :vehicle_type
    a.string    :first_name
    a.string    :last_name
    a.string    :email
    a.integer   :phone_number
  end

  validates :first_name, :last_name,
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
      :first_name          => first_name,
      :last_name           => last_name,
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
    @rates ||= Services::Rates.fetch(rental: self, location: Location.first)
  end

  def save
    Public::RentalConfirmation.customer(success_args).deliver_now
    Public::RentalConfirmation.samay(success_args).deliver_now
  end
end
