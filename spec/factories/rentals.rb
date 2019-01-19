# == Schema Information
#
# Table name: rentals
#
#  id                                                   :bigint(8)        not null, primary key
#  created_at                                           :datetime         not null
#  updated_at                                           :datetime         not null
#  number                                               :string
#  source                                               :string
#  status                                               :string
#  confirmed                                            :boolean
#  driver_id                                            :bigint(8)
#  additional_driver_id                                 :bigint(8)
#  vehicle_id                                           :bigint(8)
#  tax_rate_id                                          :bigint(8)
#  notes                                                :text
#  pickup_location_id                                   :bigint(8)
#  pickup                                               :datetime
#  pickup_odometer                                      :bigint(8)
#  pickup_fuel                                          :float
#  drop_off_location_id                                 :bigint(8)
#  drop_off                                             :datetime
#  drop_off_odometer                                    :bigint(8)
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

FactoryBot.define do

  factory :rental do
    trait :open do
      status { Rental::OPEN }
    end

    trait :closed do
      status { Rental::CLOSED }
    end

    trait :add_dates do
      pickup { Date.today - 4.days }
      drop_off { Date.today + 1.days }
    end

    trait :add_miles do
      pickup_odometer { 100 }
      drop_off_odometer { 200 }
    end

    pickup_location { create(:location) }
    drop_off_location { pickup_location }

    tax_rate { create(:tax_rate, location: pickup_location) }
    driver { create(:driver) }
    vehicle { create(:vehicle, location: pickup_location, original_location: pickup_location) }
  end
end
