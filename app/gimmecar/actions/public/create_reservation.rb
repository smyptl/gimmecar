class Actions::Public::CreateReservation < Lib::Forms::Base

  attributes do |a|
    a.date_time :pickup
    a.date_time :drop_off
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
      :vehicle             => "Toyota Corolla",
      :location            => "Super 8 Redlands - 1160 Arizona St. Redlands, CA 92374",
      :first_name          => first_name,
      :last_name           => last_name,
      :email               => email,
      :phone_number        => phone_number,
      :confirmation_number => confirmation_number,
      :pickup              => pickup,
      :drop_off            => drop_off,
    }.merge(calculate_rental.fetch)
  end

  def confirmation_number
    @confirmation_number ||= SecureRandom.hex(3)
  end

  def calculate_rental
    Logic::CalculateRental.new(self)
  end

  def save
    Public::RentalConfirmation.customer(success_args).deliver_now
    Public::RentalConfirmation.samay(success_args).deliver_now
  end
end
