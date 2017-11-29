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
  has_many :reservations, -> { reserved }, class_name: 'Rental', foreign_key: 'pickup_location_id'

  has_many :today_drop_offs, -> { drop_off_rentals.where(date: DateTime.now) }

  has_many :vehicles

  has_many :rates, -> { where(default: false) }
  has_many :default_rates, -> { where(default: true) }, class_name: 'Rate'
  has_many :tax_rates
  has_one :latest_tax_rate, -> { order(created_at: :desc) }, class_name: 'TaxRate'

  def description
    "#{name} - #{address_1} #{city}, #{state} #{zip_code}"
  end

  def default_rate_for(vehicle_type)
    default_rates.find_by(vehicle_type: vehicle_type)
  end

  def find_rate_by(vehicle_type:, date:)
    date = convert_date_to_time_zone(date) if date === DateTime
    rates.find_by(vehicle_type: vehicle_type, date: date)
  end

  def rates_for(vehicle_type:, date:)
    find_rate_by(vehicle_type: vehicle_type, date: date) || default_rate_for(vehicle_type)
  end

  def latest_combined_tax_rate
    latest_tax_rate.combined_tax_rate
  end

  def calendar
    open_rentals + reservations
  end

  def available_vehicles(vehicle_type:, date_range:)
    vehicles.where(vehicle_type: vehicle_type).select { |v| v.available? }
  end

  def available_vehicle_ids(vehicle_type:, date_range:)
    available_vehicles(vehicle_type: vehicle_type, date_range: date_range).pluck(:id)
  end

  def vehicle_ids
    vehicles.pluck(:id)
  end

  def vehicle_vins
    vehicles.pluck(:vin)
  end

  def rental_numbers
    rentals.pluck(:number)
  end

  def convert_date_to_time_zone(date_time)
    convert_date_time_to_time_zone(date_time).to_date
  end

  def convert_date_time_to_time_zone(date_time)
    date_time.in_time_zone('Pacific Time (US & Canada)')
  end
end
