require 'spec_helper'
require 'factories/tax_rates'

describe LineItem do

  describe '.calculate' do
    it 'no discount' do
      calculations = LineItem.calculate(amount: 100, tax_rate: build(:tax_rate))

      expect(calculations['quantity']).to eq(1)
      expect(calculations['amount']).to eq(100)
      expect(calculations['discount']).to eq(0)
      expect(calculations['sub_total']).to eq(100)
      expect(calculations['taxable_amount']).to eq(100)
      expect(calculations['total']).to eq(108)
    end

    it 'includes discount' do
      calculations = LineItem.calculate(amount: 10000, discount: 1500, tax_rate: build(:tax_rate))

      expect(calculations['quantity']).to eq(1)
      expect(calculations['amount']).to eq(10000)
      expect(calculations['discount']).to eq(1500)
      expect(calculations['sub_total']).to eq(10000)
      expect(calculations['taxable_amount']).to eq(8500)
      expect(calculations['total']).to eq(9159)
    end

    it 'no taxable_amount' do
      calculations = LineItem.calculate(amount: 10000, taxable_amount: 0, tax_rate: build(:tax_rate))

      expect(calculations['quantity']).to eq(1)
      expect(calculations['amount']).to eq(10000)
      expect(calculations['discount']).to eq(0)
      expect(calculations['sub_total']).to eq(10000)
      expect(calculations['taxable_amount']).to eq(0)
      expect(calculations['total']).to eq(10000)
    end
  end
end
