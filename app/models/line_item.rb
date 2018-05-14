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
