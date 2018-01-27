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
  has_one :open_rental, -> { where(status: Rental::OPEN) }, class_name: 'Rental'
  has_one :last_rental, -> { past }, class_name: 'Rental'
  has_many :rental_line_items, -> {  }

  belongs_to :original_location, class_name: 'Location'
  belongs_to :location

  delegate :name, to: :location, prefix: true

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
    !open_rental.blank?
  end

  def make_model
    "#{make} #{model}"
  end

  def status
    return 'rented' if open_rental?
    super
  end
end
