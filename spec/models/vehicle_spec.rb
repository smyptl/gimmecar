# == Schema Information
#
# Table name: vehicles
#
#  id                   :bigint(8)        not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  original_location_id :bigint(8)
#  location_id          :bigint(8)
#  vehicle_type         :string
#  vin                  :string
#  license_number       :string
#  make                 :string
#  model                :string
#  year                 :integer
#  color                :string
#  original_odometer    :integer
#  transmission         :string
#  power_train          :string
#  cylinders            :integer
#  fuel_grade           :string
#  tank_size            :integer
#  notes                :text
#  status               :string
#

require 'spec_helper'

require 'factories/vehicles'
require 'factories/rentals'

describe Vehicle do

  describe '.rental_latest' do

    it 'returns latest rental' do
      vehicle = create(:vehicle)
      create(:rental, vehicle: vehicle, drop_off: Date.new(2018, 1, 15))
      rental = create(:rental, vehicle: vehicle, drop_off: Date.new(2018, 2, 15))

      expect(vehicle.rental_latest).to eq(rental)
    end
  end
end
