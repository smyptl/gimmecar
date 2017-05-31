# == Schema Information
#
# Table name: rates
#
#  id           :integer          not null, primary key
#  location_id  :integer
#  date         :date
#  rate         :integer
#  vehicle_type :string
#

class Rate < ApplicationRecord

  VEHICLE_TYPES = [:compact]

  belongs_to :location

end
