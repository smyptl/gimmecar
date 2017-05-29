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

require 'factories/drivers'
require 'factories/vehicles'

FactoryGirl.define do

  factory :rental do

    trait :open do
      status 'open'
    end

    drop_off_location { pickup_location }

    driver { create(:driver) }
    vehicle { create(:vehicle, location: pickup_location, original_location: pickup_location) }
  end
end
