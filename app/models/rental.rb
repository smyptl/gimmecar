# == Schema Information
#
# Table name: rentals
#
#  id                 :integer          not null, primary key
#  driver_id          :integer
#  vehicle_id         :integer
#  status             :string
#  notes              :text
#  pickup_location_id :integer
#  pickup_date        :date
#  pickup_time        :time
#  pickup_odometer    :integer
#  pickup_fuel        :integer
#  return_location_id :integer
#  return_date        :date
#  return_time        :time
#  return_odometer    :integer
#  return_fuel        :integer
#  vehicle_type       :string
#

class Rental < ApplicationRecord
end
