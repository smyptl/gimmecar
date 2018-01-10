require 'spec_helper'
require 'factories/locations'
require 'factories/tax_rates'

describe Logic::Rates::Base do

  let(:location) { create(:location) }
  let(:tax_rate) { create(:tax_rate, location: location) }

  describe '#fetch' do

    it 'returns array of rates for each day' do

      results = Logic::Rates::Base.new(
        rental_period: Lib::DateRange.new(
          DateTime.new(2018, 1, 1, 0, 0, 0, '-08:00'),
          DateTime.new(2018, 1, 4, 0, 0, 0, '-08:00')),
        location: location,
        base_rate: 3000,
        tax_rate: tax_rate).fetch

      expect(results.count).to eq(3)
      expect(results[0][:date]).to eq(Date.new(2018, 1, 1))
      expect(results[1][:date]).to eq(Date.new(2018, 1, 2))
      expect(results[2][:date]).to eq(Date.new(2018, 1, 3))
    end

    describe 'partial day' do
      it 'returns full day if greater than 2 hours' do

        results = Logic::Rates::Base.new(
          rental_period: Lib::DateRange.new(
            DateTime.new(2018, 1, 1, 4, 0, 0, '-08:00'),
            DateTime.new(2018, 1, 3, 7, 0, 0, '-08:00')),
          location: location,
          base_rate: 3000,
          tax_rate: tax_rate).fetch

        expect(results.count).to eq(3)
        expect(results[0][:date]).to eq(Date.new(2018, 1, 1))
        expect(results[1][:date]).to eq(Date.new(2018, 1, 2))
        expect(results[2][:date]).to eq(Date.new(2018, 1, 3))
      end

      it 'returns full day if for just one day' do
        results = Logic::Rates::Base.new(
          rental_period: Lib::DateRange.new(
            DateTime.new(2018, 1, 1, 4, 0, 0, '-08:00'),
            DateTime.new(2018, 1, 1, 7, 0, 0, '-08:00')),
          location: location,
          base_rate: 3000,
          tax_rate: tax_rate).fetch

        expect(results.count).to eq(1)
        expect(results[0][:date]).to eq(Date.new(2018, 1, 1))
      end
    end
  end
end
