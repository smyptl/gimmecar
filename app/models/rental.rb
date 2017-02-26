# == Schema Information
#
# Table name: rentals
#
#  id                                 :integer          not null, primary key
#  number                             :string
#  source                             :string
#  status                             :string
#  confirmed                          :boolean
#  driver_id                          :integer
#  additional_driver_id               :integer
#  vehicle_id                         :integer
#  vehicle_type                       :string
#  notes                              :text
#  pickup_location_id                 :integer
#  pickup                             :datetime
#  pickup_odometer                    :decimal(10, )
#  decimal                            :decimal(10, )
#  pickup_fuel                        :float
#  drop_off_location_id               :integer
#  drop_off                           :datetime
#  drop_off_odometer                  :decimal(10, )
#  drop_off_fuel                      :float
#  collision_damage_waiver            :boolean
#  financial_responsibility_signature :text
#  driver_signature                   :text
#  additional_driver_signature        :text
#

class Rental < ApplicationRecord

  OPEN = 'open'

  belongs_to :driver
  belongs_to :additional_driver, class_name: 'Driver', required: false
  belongs_to :vehicle

  belongs_to :pickup_location,   class_name: 'Location'
  belongs_to :drop_off_location, class_name: 'Location'

  has_many :charges

  scope :reserved,  -> { where(status: 'reserved') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :open,      -> { where(status: OPEN) }
  scope :closed,    -> { where(status: 'closed') }

  scope :past, -> { where('drop_off < ?', Date.today) }

  before_create :create_number

  def self.create_open(args)
    create(args.merge(:status => OPEN))
  end

  private

  def create_number
    begin
      number = SecureRandom.hex(4)
    end while Rental.exists?(number: number)

    self.number = number
  end
end
