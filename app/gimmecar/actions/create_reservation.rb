class Actions::CreateReservation < Lib::Forms::Base
  include Lib::Forms::Actions

  attribute :pickup_date,   :date
  attribute :pickup_time,   :time
  attribute :drop_off_date, :date
  attribute :drop_off_time, :time

  attribute :first_name,    :string
  attribute :last_name,     :string
  attribute :email,         :string
  attribute :phone_number,  :integer

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

  def pickup
    return unless pickup_date && pickup_time
    @pickup ||= Lib::DateTime.create(pickup_date, pickup_time)
  end

  def drop_off
    return unless drop_off_date && drop_off_time
    @drop_off ||= Lib::DateTime.create(drop_off_date, drop_off_time)
  end

  def failure_args
    {
      :errors => errors,
    }
  end

  def success_args
    {
      :vehicle             => "Toyota Corolla",
      :location            => "Super 8 Redlands - 1160 Arizona St. Redlands, CA 92374",
      :first_name          => first_name,
      :last_name           => last_name,
      :confirmation_number => confirmation_number,
      :pickup              => pickup,
      :drop_off            => drop_off,
      :rates               => calculate_rental.rates,
      :tax                 => calculate_rental.tax,
      :total               => calculate_rental.total
    }
  end

  def confirmation_number
    @confirmation_number ||= SecureRandom.hex(3)
  end

  def calculate_rental
    @calculate_rental ||= Logic::CalculateRental.new(self)
  end

  def save
  end
end
