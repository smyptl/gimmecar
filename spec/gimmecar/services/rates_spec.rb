require "spec_helper"
require 'factories/locations'
require 'factories/rates'
require 'factories/tax_rates'
require 'factories/rentals'

describe Services::Rates do

  let(:location) { create(:location) }
  let(:tax_rates) { create(:tax_rate, location: location) }

  describe "#rates" do
    it "returns array of rates for each day" do
      location
      tax_rates

      create(:rate, location: location, vehicle_type: :compact, date: Date.new(2011, 1, 1), :amount => 1000)
      create(:rate, location: location, vehicle_type: :compact, date: Date.new(2011, 1, 2), :amount => 3000)
      create(:rate, location: location, vehicle_type: :compact, date: Date.new(2011, 1, 3), :amount => 2000)

      rental = Services::Rates.fetch(:location => location,
                      :rental => double(:rental,
                        :vehicle_type => 'compact',
                        :pickup   => DateTime.new(2011, 1, 1),
                        :drop_off => DateTime.new(2011, 1, 4)))

      expect(rental[:line_items].count).to eq(3)
      expect(rental[:line_items].first[:taxable_amount]).to eq(1000)
      expect(rental[:line_items].first[:tax_collectable]).to eq(272)

      expect(rental[:total]).to eq(11316)
      expect(rental[:sub_total]).to eq(10500)
      expect(rental[:tax_collectable]).to eq(816)
      expect(rental[:combined_tax_rate]).to eq(tax_rates.combined_tax_rate)
    end

    describe "partial day" do
      it "returns full value if greater than 2 hours" do
        location
        tax_rates

        rental = Services::Rates.fetch(:location => location,
                        :rental => double(:rental,
                          :pickup   => DateTime.new(2011, 1, 1, 4, 0, 0),
                          :drop_off => DateTime.new(2011, 1, 2, 7, 0, 0)))

        expect(rental[:line_items].count).to eq(2)
        expect(rental[:line_items].first[:taxable_amount]).to eq(3500)
        expect(rental[:line_items].first[:tax_collectable]).to eq(272)

        expect(rental[:total]).to eq(7544)
        expect(rental[:sub_total]).to eq(7000)
        expect(rental[:tax_collectable]).to eq(544)
      end

      it "returns parital value if less than 3 hours" do
        location
        tax_rates

        rental = Services::Rates.fetch(:location => location,
                        :rental => double(:rental,
                          :pickup   => DateTime.new(2011, 1, 1, 4, 0, 0),
                          :drop_off => DateTime.new(2011, 1, 2, 6, 0, 0)))

        expect(rental[:line_items].count).to eq(2)
        expect(rental[:line_items].first[:date]).to eq(Date.new(2011, 1, 1))
        expect(rental[:line_items].first[:taxable_amount]).to eq(3500)
        expect(rental[:line_items].first[:tax_collectable]).to eq(272)
        expect(rental[:line_items].second[:date]).to eq(Date.new(2011, 1, 2))
        expect(rental[:line_items].second[:taxable_amount]).to eq(2334)
        expect(rental[:line_items].second[:tax_collectable]).to eq(181)

        expect(rental[:total]).to eq(6287)
        expect(rental[:sub_total]).to eq(5834)
        expect(rental[:tax_collectable]).to eq(453)
      end

      it 'returns last date for partial if rental is greater than 24 hours' do
        location
        tax_rates

        rental = Services::Rates.fetch(:location => location,
                        :rental => double(:rental,
                          :pickup   => DateTime.new(2011, 1, 1, 3, 0, 0),
                          :drop_off => DateTime.new(2011, 1, 3, 4, 0, 0)))

        expect(rental[:line_items].count).to eq(3)
        expect(rental[:line_items].first[:taxable_amount]).to eq(3500)
        expect(rental[:line_items].first[:tax_collectable]).to eq(272)
        expect(rental[:line_items].last[:taxable_amount]).to eq(1167)
        expect(rental[:line_items].last[:tax_collectable]).to eq(91)
      end

      it 'actual example' do
        location
        tax_rates

        rental = Services::Rates.fetch(:location => location,
                        :rental => double(:rental,
                          :pickup   => DateTime.new(2017, 1, 31, 10, 57, 0),
                          :drop_off => DateTime.new(2017, 2, 5, 9, 57, 0)))

        expect(rental[:line_items].count).to eq(5)
        expect(rental[:line_items].first[:taxable_amount]).to eq(3500)
        expect(rental[:line_items].first[:tax_collectable]).to eq(272)
      end
    end
  end
end
