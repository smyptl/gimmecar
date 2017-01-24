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

FactoryGirl.define do

  factory :rental do

    trait :quote do
      status 'quote'
    end

    trait :rented do
      status 'rented'
    end
  end
end
