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
