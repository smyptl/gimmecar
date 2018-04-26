require 'spec_helper'
require 'factories/locations'
require 'factories/rentals'
require 'factories/vehicles'
require 'factories/line_items'

describe Services::Command::Location::Metrics do
  describe '#retrieve!' do
    it 'outputs metrics by vehicle type' do
      location = create(:location)
      vehicle  = create(:vehicle, :compact)
      rental   = create(:rental, :closed, :add_miles, pickup_location: location, vehicle: vehicle)
      create(:line_item, :rental_rate, invoice: rental, sub_total: 1000)

      results = Services::Command::Location::Metrics.new(slug: location.slug).retrieve!

      expect(results[0].keys).to include(:vehicle_type, :price_per_mile)
    end
  end
end
