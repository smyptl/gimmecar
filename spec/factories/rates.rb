# == Schema Information
#
# Table name: rates
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location_id  :integer
#  default      :boolean          default(FALSE)
#  date         :date
#  amount       :integer
#  vehicle_type :string
#

FactoryGirl.define do
  factory :rate do

    trait :default do
      default true
    end
  end
end
