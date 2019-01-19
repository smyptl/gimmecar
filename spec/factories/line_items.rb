# == Schema Information
#
# Table name: line_items
#
#  id                      :bigint(8)        not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  invoice_type            :string
#  invoice_id              :bigint(8)
#  charge_id               :bigint(8)
#  item_type               :string
#  details                 :json
#  date                    :date
#  quantity                :integer
#  total                   :bigint(8)
#  amount                  :bigint(8)
#  discount                :bigint(8)
#  sub_total               :bigint(8)
#  taxable_amount          :bigint(8)
#  tax_collectable         :bigint(8)
#  state_taxable_amount    :bigint(8)
#  state_amount            :bigint(8)
#  county_taxable_amount   :bigint(8)
#  county_amount           :bigint(8)
#  city_taxable_amount     :bigint(8)
#  city_amount             :bigint(8)
#  district_taxable_amount :bigint(8)
#  district_amount         :bigint(8)
#  description             :text
#

require 'factories/charges'

FactoryBot.define do
  factory :line_item do
    total { 0 }
    sub_total { 0 }
    amount { 0 }

    trait :deposit do
      item_type { :deposit }
    end

    trait :rental_rate do
      item_type { :rental_rate }
    end

    charge { create(:charge, owner: invoice) }
  end
end
