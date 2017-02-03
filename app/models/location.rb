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

  has_many :current_rentals, -> { rented }, class_name: 'Rental', foreign_key: 'pickup_location_id'
  has_many :future_rentals, -> { reserved }, class_name: 'Rental', foreign_key: 'pickup_location_id'

  has_many :today_drop_offs, -> { drop_off_rentals.where(date: DateTime.now) }

  has_many :vehicles

  def description
  end

  def calendar
    current_rentals + future_rentals
  end
end
