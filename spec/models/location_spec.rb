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

describe Location do

  describe "#current_rentals" do

    it "returns all cars currently rented" do
      location = create(:location)

      rented = create(:rental, :rented, pickup_location: location)
      create(:rental, :quote, pickup_location: location)

      expect(location.current_rentals).to eq([rented])
    end
  end
end
