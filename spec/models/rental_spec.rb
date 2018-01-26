require 'spec_helper'
require 'factories/rentals'

describe Rental do

  describe '.in_between' do

    let(:rental) { create(:rental, pickup: Date.new(2018, 1, 6), drop_off: Date.new(2018, 1, 9)) }

    it 'returns rental between a date' do
      rental

      results = Rental.in_between(rental.pickup + 1.day)

      expect(results.count).to eq(1)
      expect(results).to include(rental)
    end

    it 'returns empty array if no date' do
      rental

      results = Rental.in_between(rental.drop_off + 10.days)

      expect(results.count).to eq(0)
    end
  end
end
