require 'spec_helper'
require 'factories/rentals'
require 'factories/line_items'

describe Logic::Metrics::Location::PricePerMile do
  describe '#calculate' do
    it 'returns average price per mile driven' do
      vehicle = create(:vehicle, :subcompact)

      rental = create(:rental,
                      :closed,
                      vehicle: vehicle,
                      pickup_odometer: 1000,
                      drop_off_odometer: 2000)

      create(:line_item,
             :rental_rate,
             invoice: rental,
             sub_total: 10000)

      results = Logic::Metrics::Location::PricePerMile.new(rental.pickup_location).calculate

      expect(results[0]).to eq({
        vehicle_type: 'subcompact',
        metrics:       10,
      })
    end
  end
end
