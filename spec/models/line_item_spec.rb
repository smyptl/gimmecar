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

require 'spec_helper'
require 'factories/tax_rates'
require 'factories/rentals'
require 'factories/line_items'

describe LineItem do

  describe '.unreturned_deposits' do
    it 'returns line_items with closed rentals' do
      deposit = create(:line_item, :deposit, invoice: create(:rental, :closed))
      create(:line_item, :deposit, invoice: create(:rental, :open))

      results = LineItem.deposits_unreturned
      expect(results).to eq([deposit])
    end
  end

  describe '.calculate' do
    it 'no discount' do
      calculations = LineItem.calculate(date: nil, amount: 100, tax_rate: build(:tax_rate))

      expect(calculations.fetch(:quantity)).to eq(1)
      expect(calculations.fetch(:amount)).to eq(100)
      expect(calculations.fetch(:discount)).to eq(0)
      expect(calculations.fetch(:sub_total)).to eq(100)
      expect(calculations.fetch(:taxable_amount)).to eq(100)
      expect(calculations.fetch(:total)).to eq(108)
    end

    it 'includes discount' do
      calculations = LineItem.calculate(date: nil, amount: 10000, discount: 1500, tax_rate: build(:tax_rate))

      expect(calculations.fetch(:quantity)).to eq(1)
      expect(calculations.fetch(:amount)).to eq(10000)
      expect(calculations.fetch(:discount)).to eq(1500)
      expect(calculations.fetch(:sub_total)).to eq(10000)
      expect(calculations.fetch(:taxable_amount)).to eq(8500)
      expect(calculations.fetch(:total)).to eq(9159)
    end

    it 'no taxable_amount' do
      calculations = LineItem.calculate(date: nil, amount: 10000, taxable_amount: 0, tax_rate: build(:tax_rate))

      expect(calculations.fetch(:quantity)).to eq(1)
      expect(calculations.fetch(:amount)).to eq(10000)
      expect(calculations.fetch(:discount)).to eq(0)
      expect(calculations.fetch(:sub_total)).to eq(10000)
      expect(calculations.fetch(:taxable_amount)).to eq(0)
      expect(calculations.fetch(:total)).to eq(10000)
    end
  end
end
