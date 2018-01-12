require "spec_helper"
require 'factories/locations'
require 'factories/rates'

describe Services::Admin::Location::Rates do

  describe "#fetch" do
    it "returns a list of rates for vehicles" do
      location = create(:location)

      Vehicle::TYPES.each do |vehicle_type|
        create(:rate, location: location, vehicle_type: vehicle_type, amount: 3000)
      end

      output = Services::Admin::Location::Rates.new(location.id).fetch

      expect(output.count).to eq(Vehicle::TYPES.count)

      compact_rate = output.find { |o| o[:vehicle_type] == 'compact' }
      expect(compact_rate[:rate]).to eq(3000)
    end
  end
end
