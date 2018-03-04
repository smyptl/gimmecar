require 'spec_helper'
require 'factories/locations'
require 'factories/rates'
require 'factories/tax_rates'
require 'factories/rentals'

describe Services::Rates do

  let(:location) { create(:location) }
  let(:tax_rates) { create(:tax_rate, location: location) }

  describe '#rates' do
    it 'returns array of rates for each day' do
      location
      tax_rates
      create(:rate, location: location, vehicle_type: :mid_size, :amount => 2000)

      rental = Services::Rates.new(:location => location,
                      :rental => double(:rental,
                        :vehicle_type   => 'mid_size',
                        :pickup         => Time.new(2011, 1, 1, 0, 0, 0, '-08:00'),
                        :drop_off       => Time.new(2011, 1, 4, 0, 0, 0, '-08:00'))).retrieve!

      expect(rental[:rates].count).to eq(3)
      expect(rental[:combined_tax_rate]).to eq(tax_rates.combined_tax_rate)
    end

    describe 'partial day' do
      it 'actual example' do
        location
        tax_rates
        create(:rate, location: location, vehicle_type: :mid_size, :amount => 3500)

        rental = Services::Rates.new(:location => location,
                        :rental => double(:rental,
                          :vehicle_type => 'mid_size',
                          :pickup       => Time.new(2017, 1, 31, 10, 57, 0, '-07:00'),
                          :drop_off     => Time.new(2017, 2, 5, 9, 57, 0, '-07:00'))).retrieve!

        expect(rental[:rates].count).to eq(5)
      end
    end
  end
end
