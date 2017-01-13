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
