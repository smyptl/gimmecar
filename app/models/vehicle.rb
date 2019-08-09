# == Schema Information
#
# Table name: vehicles
#
#  id                   :bigint(8)        not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  original_location_id :bigint(8)
#  location_id          :bigint(8)
#  vehicle_type         :string
#  vin                  :string
#  license_number       :string
#  make                 :string
#  model                :string
#  year                 :integer
#  color                :string
#  original_odometer    :integer
#  transmission         :string
#  power_train          :string
#  cylinders            :integer
#  fuel_grade           :string
#  tank_size            :integer
#  notes                :text
#  status               :string
#  date_commissioned    :date
#  date_decommissioned  :date
#  purchase_price       :integer
#

class Vehicle < ApplicationRecord

  STATUS = ['clean', 'dirty', 'service']
  TYPES = ['subcompact', 'compact']

  belongs_to :original_location, class_name: 'Location'
  belongs_to :location, required: false

  has_many :vehicle_registrations

  has_many :rentals
  has_many :rentals_closed, -> { closed },                 class_name: 'Rental'
  has_one :rental_open,     -> { open_status },            class_name: 'Rental'
  has_one :rental_latest,   -> { order(drop_off: :desc) }, class_name: 'Rental'
  has_many :rental_rates, through: :rentals
  has_many :line_items, through: :rentals

  scope :vehicle_type, -> (type) { where(vehicle_type: type) }
  scope :commissioned, -> { where(date_decommissioned: nil) }
  scope :decommissioned, -> { where.not(date_decommissioned: nil) }

  delegate :name, :slug, to: :location, prefix: true, allow_nil: true

  def update_status_dirty
    update(status: 'dirty')
  end

  def available?
    !rental_open? && !decommissioned?
  end

  def dirty?
    status == 'dirty'
  end

  def decommissioned?
    date_decommissioned.present?
  end

  def rental_open?
    rental_open.present?
  end

  def make_model
    "#{make} #{model}"
  end

  def odometer
    if rental_latest
      (rental_latest.drop_off_odometer || rental_latest.pickup_odometer)
    else
      original_odometer
    end
  end

  def fuel_level
    (rental_latest.drop_off_fuel || rental_latest.pickup_fuel) if rental_latest
  end

  def status
    return 'decommissioned' if decommissioned?
    return 'rented'         if rental_open?
    super
  end
end
