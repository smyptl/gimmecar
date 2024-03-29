# == Schema Information
#
# Table name: tax_rates
#
#  id                :bigint(8)        not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  location_id       :bigint(8)
#  combined_tax_rate :decimal(14, 4)
#  state_tax_rate    :decimal(14, 4)
#  county_tax_rate   :decimal(14, 4)
#  city_tax_rate     :decimal(14, 4)
#  district_tax_rate :decimal(14, 4)
#

class TaxRate < ApplicationRecord

  belongs_to :location
  has_many :line_items

  delegate :convert_date_to_time_zone, to: :location

  def calculate(taxable_amount)
    state_amount    = (taxable_amount*state_tax_rate).round
    county_amount   = (taxable_amount*county_tax_rate).round
    city_amount     = (taxable_amount*city_tax_rate).round
    district_amount = (taxable_amount*district_tax_rate).round

    {
      taxable_amount:          taxable_amount,
      tax_collectable:         (state_amount + county_amount + city_amount + district_amount),
      state_taxable_amount:    taxable_amount,
      state_amount:            state_amount,
      county_taxable_amount:   taxable_amount,
      county_amount:           county_amount,
      city_taxable_amount:     taxable_amount,
      city_amount:             city_amount,
      district_taxable_amount: taxable_amount,
      district_amount:         district_amount,
    }
  end
end
