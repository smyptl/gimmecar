require "spec_helper"
require 'factories/locations'
require 'factories/rates'

describe Services::Admin::Location::Rates do

  describe "#fetch" do
    it "returns a list of rates for vehicles" do
      location = create(:location)

      Vehicle::TYPES.each do |vehicle_type|
        create(:rate, :default, location: location, vehicle_type: vehicle_type, amount: 3000)
      end

      create(:rate, location: location, vehicle_type: 'compact', amount: 2000, date: Date.new(2017, 6, 1))

      output = Services::Admin::Location::Rates.new(location.id).during_period(DateTime.new(2017, 5, 29), DateTime.new(2017, 6, 3)).fetch

      expect(output.count).to eq(Vehicle::TYPES.count)

      compact_rate = output.find { |o| o[:vehicle_type] == 'compact' }
      expect(compact_rate[:default_rate]).to eq(3000)
      expect(compact_rate[:rates].count).to eq(1)
      expect(compact_rate[:rates].first).to eq({ date: Date.new(2017, 6, 1), amount: 2000})
    end
  end
end
