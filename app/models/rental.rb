# == Schema Information
#
# Table name: rentals
#
#  id                                                   :integer          not null, primary key
#  number                                               :string
#  source                                               :string
#  status                                               :string
#  confirmed                                            :boolean
#  driver_id                                            :integer
#  additional_driver_id                                 :integer
#  vehicle_id                                           :integer
#  vehicle_type                                         :string
#  notes                                                :text
#  pickup_location_id                                   :integer
#  pickup                                               :datetime
#  pickup_odometer                                      :integer
#  pickup_fuel                                          :float
#  drop_off_location_id                                 :integer
#  drop_off                                             :datetime
#  drop_off_odometer                                    :integer
#  drop_off_fuel                                        :float
#  collision_damage_waiver                              :boolean
#  driver_financial_responsibility_signature            :text
#  additional_driver_financial_responsibility_signature :text
#  driver_signature                                     :text
#  additional_driver_signature                          :text
#

class Rental < ApplicationRecord

  OPEN   = 'open'
  CLOSED = 'closed'

  belongs_to :driver
  belongs_to :additional_driver, class_name: 'Driver', required: false
  belongs_to :vehicle

  belongs_to :pickup_location,   class_name: 'Location'
  belongs_to :drop_off_location, class_name: 'Location'

  has_many :line_items, as: :invoice
  has_many :charges, as: :owner

  scope :reserved,  -> { where(status: 'reserved') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :open,      -> { where(status: OPEN) }
  scope :closed,    -> { where(status: CLOSED) }

  scope :past, -> { where('drop_off < ?', Date.today) }

  before_create :create_number

  delegate :name, to: :driver, prefix: true
  delegate :name, to: :additional_driver, prefix: true, allow_nil: true
  delegate :make_model, to: :vehicle, prefix: true

  delegate :description, to: :pickup_location, prefix: true
  delegate :latest_tax_rate, to: :pickup_location

  def self.create_open(args)
    create(args.merge(:status => OPEN))
  end

  def rental_period
    Lib::DateRange.new(pickup, drop_off)
  end

  def total
    line_items.sum(&:total)
  end

  def calculate_tax(line_item)
    line_item.calculate_tax(latest_tax_rate)
  end

  private

  def create_number
    begin
      number = SecureRandom.hex(4)
    end while Rental.exists?(number: number)

    self.number = number
  end
end
