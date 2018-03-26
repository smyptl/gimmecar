require 'spec_helper'
require 'factories/vehicles'
require 'factories/rentals'
require 'factories/line_items'

describe Services::Command::Vehicle::Revenue do

  describe '#retrieve!' do
    it 'groups revenue by date' do
      vehicle = create(:vehicle)
      rental_1 = create(:rental, vehicle: vehicle)
      create(:line_item, :rental_rate, invoice: rental_1, sub_total: 1000, date: Date.new(2017, 3, 10))

      rental_2 = create(:rental, vehicle: vehicle)
      create(:line_item, :rental_rate, invoice: rental_2, sub_total: 500, date: Date.new(2017, 4, 10))

      results = Services::Command::Vehicle::Revenue.new(vin: vehicle.vin).retrieve!

      expect(results).to_not eq(nil)
      expect(results.count).to eq(2)
      expect(results['Mar 2017']).to eq(1000)
      expect(results['Apr 2017']).to eq(500)
    end
  end
end
