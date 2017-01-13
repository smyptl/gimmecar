# == Schema Information
#
# Table name: rentals
#
#  id                  :integer          not null, primary key
#  number              :string
#  status              :string
#  driver_id           :integer
#  vehicle_id          :integer
#  notes               :text
#  pickup_location_id  :integer
#  pickup              :datetime
#  pickup_odometer     :integer
#  pickup_fuel         :float
#  drop_ff_location_id :integer
#  drop_off            :datetime
#  drop_off_odometer   :integer
#  drop_off_fuel       :float
#  vehicle_type        :string
#

class Rental < ApplicationRecord

  belongs_to :driver
  belongs_to :vehicle

  belongs_to :pickup_location,   class_name: 'Location'
  belongs_to :drop_off_location, class_name: 'Location'

  scope :reserved,  -> { where(status: 'reserved') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :rented,    -> { where(status: 'rented') }
  scope :closed,    -> { where(status: 'closed') }

  scope :past, -> { where('drop_off < ?', Date.today) }

end
