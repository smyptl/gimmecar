# == Schema Information
#
# Table name: rentals
#
#  id                                                   :integer          not null, primary key
#  created_at                                           :datetime         not null
#  updated_at                                           :datetime         not null
#  number                                               :string
#  source                                               :string
#  status                                               :string
#  confirmed                                            :boolean
#  driver_id                                            :integer
#  additional_driver_id                                 :integer
#  vehicle_id                                           :integer
#  tax_rate_id                                          :integer
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

require 'factories/drivers'
require 'factories/vehicles'
require 'factories/tax_rates'
require 'factories/locations'

FactoryGirl.define do

  factory :rental do

    factory :reservation do
      status Rental::RESERVED
      vehicle nil
    end

    trait :open do
      status Rental::OPEN
    end

    pickup_location { create(:location) }
    drop_off_location { pickup_location }

    tax_rate { create(:tax_rate, location: pickup_location) }
    driver factory: :driver
    vehicle { create(:vehicle, location: pickup_location, original_location: pickup_location) }
  end
end
