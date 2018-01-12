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
#  item_id                 :integer
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

class LineItem < ApplicationRecord

  belongs_to :invoice, polymorphic: true
  belongs_to :item, polymorphic: true, optional: true
  belongs_to :charge

  def self.calculate(date:, amount:, discount: 0, quantity: 1, taxable_amount: nil, tax_rate:)
    mock = self.build_mock(date: date, amount: amount, discount: discount, quantity: quantity)

    sub_total = amount
    taxable_amount ||= (amount - discount)

    mock.assign_attributes(tax_rate.calculate(taxable_amount))

    total = sub_total - discount + mock.tax_collectable

    mock.assign_attributes(sub_total: sub_total, total: total)

    mock.calculations
  end

  def calculations
    attributes.slice(
      'date',
      'quantity',
      'total',
      'amount',
      'discount',
      'sub_total',
      'taxable_amount',
      'tax_collectable',
      'state_taxable_amount',
      'state_amount',
      'county_taxable_amount',
      'county_amount',
      'city_taxable_amount',
      'city_amount',
      'district_taxable_amount',
      'district_amount').with_indifferent_access
  end
end
