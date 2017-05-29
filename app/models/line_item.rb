# == Schema Information
#
# Table name: line_items
#
#  id                      :integer          not null, primary key
#  invoice_type            :string
#  invoice_id              :integer
#  details                 :json
#  item_type               :string
#  amount                  :integer
#  tax_rate                :decimal(10, )
#  tax                     :integer
#  date                    :date
#  charge_id               :integer
#  tax_rate_id             :integer
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
#

class LineItem < ApplicationRecord

  belongs_to :invoice, polymorphic: true
  belongs_to :charge
  belongs_to :tax_rate

  def total
    amount + tax_collectable
  end

  def calculate_tax(tax_rate)
    write_attribute(:tax_rate, tax_rate)

    tax = tax_rate.calculate(taxable_amount)

    tax.each do |tax_type, amount|
      write_attribute(tax_type, amount)
    end

    self
  end
end
