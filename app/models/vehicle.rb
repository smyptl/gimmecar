# == Schema Information
#
# Table name: vehicles
#
#  id                :integer          not null, primary key
#  vehicle_type      :string
#  vin               :string
#  license_number    :string
#  make              :string
#  model             :string
#  year              :integer
#  color             :string
#  original_odometer :integer
#  transmission      :string
#  power_train       :string
#  cylinders         :integer
#  fuel_grade        :string
#  tank_size         :integer
#  notes             :text
#

class Vehicle < ApplicationRecord

  has_many :rentals
  has_one :last_rental, -> { past }

  belongs_to :original_location
  belongs_to :location

end
