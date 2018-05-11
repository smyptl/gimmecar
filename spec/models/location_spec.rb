# == Schema Information
#
# Table name: locations
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  name         :string
#  slug         :string
#  latitude     :string
#  longitude    :string
#  address_1    :string
#  address_2    :string
#  city         :string
#  state        :string
#  zip_code     :string
#  country      :string
#  phone_number :string
#

require 'spec_helper'
require 'factories/locations'
require 'factories/tax_rates'
require 'factories/rentals'
require 'factories/vehicles'

describe Location do

  describe '#latest_tax_rate' do
    it 'returns the currently rate' do
      location = create(:location)
      create(:tax_rate, location: location)
      rate = create(:tax_rate, location: location)

      expect(TaxRate.count).to eq(2)
      expect(location.latest_tax_rate).to eq(rate)
    end
  end

  describe '#rentals' do
    it 'returns pickup_locations that much location' do
      location = create(:location)
      rental = create(:rental, pickup_location: location)

      expect(location.rentals.count).to eq(1)
      expect(location.rentals).to include(rental)
    end

    it 'returns drop_off_locations that much location' do
      location = create(:location)
      rental = create(:rental, drop_off_location: location)

      expect(location.rentals.count).to eq(1)
      expect(location.rentals).to include(rental)
    end
  end

  describe '#rentals_open' do
    it 'returns all cars currently rented' do
      location = create(:location)
      rental_open = create(:rental, :open, pickup_location: location, drop_off_location: location)

      expect(location.rentals_open).to eq([rental_open])
    end
  end

  describe '#available_vehicles' do
    it 'returns list of available vehicles' do
      location = create(:location)

      vehicle_1 = create(:vehicle, vehicle_type: :compact, location: location, original_location: location)
      vehicle_2 = create(:vehicle, vehicle_type: :compact, location: location, original_location: location)
      create(:rental, :open, vehicle: vehicle_2, pickup_location: location, drop_off_location: location)
      create(:vehicle, vehicle_type: :mid_size, location: location, original_location: location)

      available_vehicles = location.available_vehicles(vehicle_type: :compact)

      expect(available_vehicles.count).to eq(1)
      expect(available_vehicles).to include(vehicle_1)
    end

    it 'returns empty list if none available' do
      location = create(:location)
      expect(location.available_vehicles(vehicle_type: :compact)).to eq([])
    end
  end
end
