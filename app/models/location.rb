# == Schema Information
#
# Table name: locations
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
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
  has_many :line_items, through: :rentals

  has_many :today_drop_offs, -> { drop_off_rentals.where(date: Time.current) }

  has_many :vehicles

  has_many :rates
  has_many :tax_rates
  has_one :latest_tax_rate, -> { order(created_at: :desc) }, class_name: 'TaxRate'

  def description
    "#{name} - #{address_1} #{city}, #{state} #{zip_code}"
  end

  def rate_for(vehicle_type)
    rates.find_by(vehicle_type: vehicle_type)
  end

  def latest_combined_tax_rate
    latest_tax_rate.combined_tax_rate
  end

  def calendar
    open_rentals + reservations
  end

  def available_vehicles(vehicle_type:)
    vehicles.where(vehicle_type: vehicle_type).select(&:available?)
  end

  def available_vehicle_ids(vehicle_type:)
    available_vehicles(vehicle_type: vehicle_type).pluck(:id)
  end

  def vehicle_ids
    vehicles.ids
  end

  def convert_date_to_time_zone(time)
    convert_time_to_time_zone(time).to_date
  end

  def convert_time_to_time_zone(time)
    time.in_time_zone(time_zone)
  end

  def time_zone
    'Pacific Time (US & Canada)'
  end
end
