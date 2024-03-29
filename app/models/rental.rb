# == Schema Information
#
# Table name: rentals
#
#  id                                                   :bigint(8)        not null, primary key
#  created_at                                           :datetime         not null
#  updated_at                                           :datetime         not null
#  number                                               :string
#  source                                               :string
#  status                                               :string
#  confirmed                                            :boolean
#  driver_id                                            :bigint(8)
#  additional_driver_id                                 :bigint(8)
#  vehicle_id                                           :bigint(8)
#  tax_rate_id                                          :bigint(8)
#  notes                                                :text
#  pickup_location_id                                   :bigint(8)
#  pickup                                               :datetime
#  pickup_odometer                                      :bigint(8)
#  pickup_fuel                                          :float
#  drop_off_location_id                                 :bigint(8)
#  drop_off                                             :datetime
#  drop_off_odometer                                    :bigint(8)
#  drop_off_fuel                                        :float
#  collision_damage_waiver                              :boolean
#  driver_financial_responsibility_signature            :text
#  additional_driver_financial_responsibility_signature :text
#  driver_signature                                     :text
#  additional_driver_signature                          :text
#

class Rental < ApplicationRecord

  DEPOSIT_AMOUNT = 20000
  LIMIT = 30

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
  has_many :rental_rates, -> { rental_rates }, class_name: 'LineItem', as: :invoice
  has_one :rental_last_rate, -> { rental_rates.order(date: :desc) }, class_name: 'LineItem', as: :invoice
  has_one :deposit, -> { deposits }, class_name: 'LineItem', as: :invoice

  has_many :charges, as: :owner

  scope :open_status,   -> { where(status: OPEN) }
  scope :closed_status, -> { where(status: CLOSED) }

  scope :in_between, -> (date) { where('pickup <= :date and drop_off >= :date', date: date) }
  scope :past,       -> { where('drop_off < ?', Time.current) }

  scope :vehicle_type, -> (type) { where(vehicle: Vehicle.vehicle_type(type)) }

  before_create :create_number

  delegate :name, :stripe_id, :stripe_sources, :license_number, to: :driver,            prefix: true
  delegate :name, :stripe_id, :stripe_sources,                  to: :additional_driver, prefix: true, allow_nil: true
  delegate :make_model,   to: :vehicle, prefix: true
  delegate :vehicle_type, to: :vehicle

  delegate :name, :slug, :description, to: :pickup_location,   prefix: true
  delegate :name, :slug, :description, to: :drop_off_location, prefix: true

  delegate :combined_tax_rate, to: :tax_rate

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
    rental_rates.sum(&:tax_collectable)
  end

  def sub_total
    rental_rates.sum(&:sub_total)
  end

  def total
    rental_rates.sum(&:total)
  end

  def rental_last_rate_amount
    rental_last_rate.try(:amount)
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
    closed? && deposit?
  end

  def deposit?
    deposit.present?
  end

  private

  def create_number
    begin
      number = SecureRandom.hex(4)
    end while Rental.exists?(number: number)

    self.number = number
  end
end
