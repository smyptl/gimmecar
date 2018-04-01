# == Schema Information
#
# Table name: line_items
#
#  id                      :integer          not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  invoice_type            :string
#  invoice_id              :integer
#  item_type               :string
#  charge_id               :integer
#  details                 :json
#  date                    :date
#  quantity                :integer
#  total                   :integer
#  amount                  :integer
#  discount                :integer
#  sub_total               :integer
#  taxable_amount          :integer
#  tax_collectable         :integer
#  state_taxable_amount    :integer
#  state_amount            :integer
#  county_taxable_amount   :integer
#  county_amount           :integer
#  city_taxable_amount     :integer
#  city_amount             :integer
#  district_taxable_amount :integer
#  district_amount         :integer
#  description             :text
#

require 'factories/charges'

FactoryBot.define do
  factory :line_item do
    trait :deposit do
      item_type :deposit
    end

    trait :rental_rate do
      item_type :rental_rate
    end

    charge { create(:charge, owner: invoice) }
  end
end
