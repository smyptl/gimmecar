# == Schema Information
#
# Table name: tax_rates
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  location_id       :integer
#  combined_tax_rate :decimal(14, 4)
#  state_tax_rate    :decimal(14, 4)
#  county_tax_rate   :decimal(14, 4)
#  city_tax_rate     :decimal(14, 4)
#  district_tax_rate :decimal(14, 4)
#

FactoryBot.define do

  factory :tax_rate do
    combined_tax_rate 0.07750
    state_tax_rate 0.06000
    county_tax_rate 0.00250
    city_tax_rate 0.00000
    district_tax_rate 0.01500
  end
end
