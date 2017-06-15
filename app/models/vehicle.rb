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
#

class Vehicle < ApplicationRecord

  has_many :rentals
  has_one :open_rental, -> { where(status: Rental::OPEN) }, class_name: 'Rental'
  has_one :last_rental, -> { past }, class_name: 'Rental'

  belongs_to :original_location, class_name: 'Location'
  belongs_to :location

  def open_rental?
    !open_rental.blank?
  end

  def make_model
    "#{make} #{model}"
  end
end
