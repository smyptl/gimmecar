# == Schema Information
#
# Table name: vehicles
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  original_location_id :integer
#  location_id          :integer
#  vehicle_type         :string
#  vin                  :string
#  license_number       :string
#  make                 :string
#  model                :string
#  year                 :integer
#  color                :string
#  original_odometer    :integer
#  transmission         :string
#  power_train          :string
#  cylinders            :integer
#  fuel_grade           :string
#  tank_size            :integer
#  notes                :text
#  status               :string
#

require 'factories/locations'

FactoryBot.define do

  factory :vehicle do
    location { create(:location) }
    original_location { location }
    vehicle_type :mid_size
    make { ['BMW', 'Toyota', 'Ford', 'Porsche'].sample }
    model '5 Series'
    year { [2017, 2018].sample }
    color { Faker::Color.color_name }
    vin { Faker::Vehicle.vin }
    license_number { SecureRandom.hex(4) }
    status :clean

    trait :compact do
      vehicle_type :compact
    end

    trait :subcompact do
      vehicle_type :subcompact
    end
  end
end
