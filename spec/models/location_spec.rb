# == Schema Information
#
# Table name: locations
#
#  id           :integer          not null, primary key
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
require 'factories/rentals'
require 'factories/vehicles'

describe Location do

  describe '#open_rentals' do

    it 'returns all cars currently rented' do
      location = create(:location)
      open_rental = create(:rental, :open, pickup_location: location, drop_off_location: location)

      expect(location.open_rentals).to eq([open_rental])
    end
  end

  describe '#available_vehicles' do

    it 'returns list of available vehicles' do
      location = create(:location)

      vehicle_1 = create(:vehicle, location: location, original_location: location)
      vehicle_2 = create(:vehicle, location: location, original_location: location)
      create(:rental, :open, vehicle: vehicle_2, pickup_location: location, drop_off_location: location)

      available_vehicles = location.available_vehicles([])

      expect(available_vehicles.count).to eq(1)
      expect(available_vehicles).to include(vehicle_1)
    end

    it 'returns empty list if none available' do
      location = create(:location)
      expect(location.available_vehicles([])).to eq([])
    end
  end
end
