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

class LineItem < ApplicationRecord

  belongs_to :invoice, polymorphic: true
  belongs_to :charge

  scope :rental_rates,   -> { where(item_type: 'rental_rate') }
  scope :deposits,       -> { where(item_type: 'deposit') }
  scope :gas,            -> { where(item_type: 'gas') }
  scope :cleaning,       -> { where(item_type: 'cleaning') }
  scope :processing_fee, -> { where(item_type: 'processing_fee') }
  scope :vehicle_damage, -> { where(item_type: 'vehicle_damage') }
  scope :deposits_unreturned, -> { includes(:invoice).deposits.where(invoice_type: 'Rental').select(&:invoice_closed?) }

  delegate :number, :closed?, to: :invoice, prefix: true

  def self.calculate(date:, amount:, discount: 0, quantity: 1, taxable_amount: nil, tax_rate:)
    date = tax_rate.convert_date_to_time_zone(date) if date
    sub_total = amount
    taxable_amount ||= (amount - discount)

    tax_calculations = tax_rate.calculate(taxable_amount)

    total = sub_total - discount + tax_calculations.fetch(:tax_collectable)

    {
      date:           date,
      quantity:       quantity,
      total:          total,
      amount:         amount,
      discount:       discount,
      sub_total:      sub_total,
      taxable_amount: taxable_amount,
    }.merge(tax_calculations).freeze
  end
end
