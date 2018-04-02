# == Schema Information
#
# Table name: rentals
#
#  id                                                   :integer          not null, primary key
#  created_at                                           :datetime         not null
#  updated_at                                           :datetime         not null
#  number                                               :string
#  source                                               :string
#  status                                               :string
#  confirmed                                            :boolean
#  driver_id                                            :integer
#  additional_driver_id                                 :integer
#  vehicle_id                                           :integer
#  tax_rate_id                                          :integer
#  notes                                                :text
#  pickup_location_id                                   :integer
#  pickup                                               :datetime
#  pickup_odometer                                      :integer
#  pickup_fuel                                          :float
#  drop_off_location_id                                 :integer
#  drop_off                                             :datetime
#  drop_off_odometer                                    :integer
#  drop_off_fuel                                        :float
#  collision_damage_waiver                              :boolean
#  driver_financial_responsibility_signature            :text
#  additional_driver_financial_responsibility_signature :text
#  driver_signature                                     :text
#  additional_driver_signature                          :text
#

class Rental < ApplicationRecord

  DEPOSIT_AMOUNT = 20000

  OPEN   = 'open'
  CLOSED = 'closed'

  belongs_to :driver
  belongs_to :additional_driver, class_name: 'Driver', required: false
  belongs_to :vehicle, required: false

  belongs_to :pickup_location,   class_name: 'Location'
  belongs_to :drop_off_location, class_name: 'Location'

  belongs_to :tax_rate
  has_one :latest_tax_rate, through: :pickup_location

  has_many :line_items, as: :invoice
  has_many :rates, -> { rental_rates }, class_name: 'LineItem', as: :invoice
  has_one :deposit, -> { deposits }, class_name: 'LineItem', as: :invoice

  has_many :charges, as: :owner

  scope :open,      -> { where(status: OPEN) }
  scope :closed,    -> { where(status: CLOSED) }

  scope :in_between, -> (date) { where('pickup <= :date and drop_off >= :date', date: date) }
  scope :past, -> { where('drop_off < ?', Time.current) }

  before_create :create_number

  delegate :name,               to: :driver,            prefix: true
  delegate :name,               to: :additional_driver, prefix: true, allow_nil: true
  delegate :make_model,         to: :vehicle,           prefix: true

  delegate :description, :name, to: :pickup_location,   prefix: true
  delegate :name,               to: :drop_off_location, prefix: true

  delegate :combined_tax_rate,  to: :tax_rate

  def self.create_open(args)
    create(args.merge(status: OPEN))
  end

  def close(args)
    update(args.merge(status: CLOSED))
  end

  def closed?
    status == CLOSED
  end

  def open?
    status == OPEN
  end

  def stripe_customer_id
    driver.stripe_id || additional_driver.stripe_id
  end

  def rental_period
    Lib::DateRange.new(pickup, drop_off)
  end

  def days_apart
    rental_period.days_apart
  end

  def tax_collectable
    rates.sum(&:tax_collectable)
  end

  def sub_total
    rates.sum(&:sub_total)
  end

  def total
    rates.sum(&:total)
  end

  def last_rental_rate
    rates.order(date: :desc).first.try(:amount)
  end

  def miles_driven
    drop_off_odometer - pickup_odometer if drop_off_odometer
  end

  def average_rate
    sub_total/rates.count if rates.present?
  end

  def average_price_per_mile
    sub_total/miles_driven if miles_driven
  end

  def deposit_amount
    deposit.total
  end

  def can_close?
    open?
  end

  def can_extend_rental?
    open?
  end

  def can_return_deposit?
    closed? && deposit.present?
  end

  private

  def create_number
    begin
      number = SecureRandom.hex(4)
    end while Rental.exists?(number: number)

    self.number = number
  end
end
