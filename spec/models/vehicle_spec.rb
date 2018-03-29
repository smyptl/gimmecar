require 'spec_helper'

require 'factories/vehicles'
require 'factories/rentals'

describe Vehicle do

  describe '.latest_rental' do

    it 'returns latest rental' do
      vehicle = create(:vehicle)
      create(:rental, vehicle: vehicle, drop_off: Date.new(2018, 1, 15))
      rental = create(:rental, vehicle: vehicle, drop_off: Date.new(2018, 2, 15))

      expect(vehicle.latest_rental).to eq(rental)
    end
  end
end
