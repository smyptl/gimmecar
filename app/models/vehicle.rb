# == Schema Information
#
# Table name: vehicles
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  original_location_id :integer
#  location_id          :integer
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
#

class Vehicle < ApplicationRecord

  STATUS = ['clean', 'dirty', 'service']
  TYPES = ['subcompact', 'compact', 'mid_size']

  has_many :rentals
  has_many :rentals_closed, -> { closed },                      class_name: 'Rental'
  has_one :open_rental,     -> { open_status },                 class_name: 'Rental'
  has_one :last_rental,     -> { past.order(drop_off: :desc) }, class_name: 'Rental'
  has_one :latest_rental,   -> { order(drop_off: :desc) },      class_name: 'Rental'
  has_many :rental_rates, through: :rentals
  has_many :line_items, through: :rentals

  belongs_to :original_location, class_name: 'Location'
  belongs_to :location

  scope :vehicle_type, -> (type) { where(vehicle_type: type) }

  delegate :name, :slug, to: :location, prefix: true

  def update_status_dirty
    update(status: 'dirty')
  end

  def available?
    !open_rental?
  end

  def dirty?
    status == 'dirty'
  end

  def open_rental?
    open_rental.present?
  end

  def make_model
    "#{make} #{model}"
  end

  def odometer
    latest_rental.drop_off_odometer || latest_rental.pickup_odometer
  end

  def fuel_level
    latest_rental.drop_off_fuel || latest_rental.pickup_fuel
  end

  def status
    return 'rented' if open_rental?
    super
  end
end
