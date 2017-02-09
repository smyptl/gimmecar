# == Schema Information
#
# Table name: rentals
#
#  id                      :integer          not null, primary key
#  number                  :string
#  source                  :string
#  status                  :string
#  confirmed               :boolean
#  driver_id               :integer
#  additional_driver_id    :integer
#  vehicle_id              :integer
#  vehicle_type            :string
#  notes                   :text
#  pickup_location_id      :integer
#  pickup                  :datetime
#  pickup_odometer         :integer
#  pickup_fuel             :float
#  drop_off_location_id    :integer
#  drop_off                :datetime
#  drop_off_odometer       :integer
#  drop_off_fuel           :float
#  collision_damage_waiver :boolean
#

class Rental < ApplicationRecord

  OPEN = 'open'

  belongs_to :driver
  belongs_to :additional_driver, class_name: 'Driver', required: false
  belongs_to :vehicle

  belongs_to :pickup_location,   class_name: 'Location'
  belongs_to :drop_off_location, class_name: 'Location'

  scope :reserved,  -> { where(status: 'reserved') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :open,      -> { where(status: OPEN) }
  scope :closed,    -> { where(status: 'closed') }

  scope :past, -> { where('drop_off < ?', Date.today) }

end
