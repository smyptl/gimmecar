# == Schema Information
#
# Table name: locations
#
#  id           :integer          not null, primary key
#  name         :string
#  slug         :string
#  latitude     :string
#  longitude    :string
#  address_1    :string
#  address_2    :string
#  city         :string
#  state        :string
#  zip_code     :string
#  country      :string
#  phone_number :string
#

class Location < ApplicationRecord

  has_and_belongs_to_many :users

  has_many :rentals, foreign_key: 'pickup_location_id'
  has_many :drop_off_rentals, class_name: 'Rental', foreign_key: 'drop_off_location_id'

  has_many :open_rentals, -> { where(status: Rental::OPEN) }, class_name: 'Rental', foreign_key: 'pickup_location_id'
  has_many :future_rentals, -> { reserved }, class_name: 'Rental', foreign_key: 'pickup_location_id'

  has_many :today_drop_offs, -> { drop_off_rentals.where(date: DateTime.now) }

  has_many :vehicles

  has_many :tax_rates
  has_one :latest_tax_rate, -> { order created_at: :desc }, class_name: 'TaxRate'

  def description
    "#{name} - #{address_1} #{city}, #{state} #{zip_code}"
  end

  def calendar
    open_rentals + future_rentals
  end

  def available_vehicles(date_range)
    vehicles.select { |v| !v.open_rental? }
  end

  def available_vehicle_ids(date_range)
    available_vehicles(date_range).pluck(:id)
  end

  def vehicle_ids
    vehicles.pluck(:id)
  end

  def rental_numbers
    rentals.pluck(:number)
  end
end
