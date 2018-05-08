# == Schema Information
#
# Table name: rentals
#
#  id                                                   :bigint(8)        not null, primary key
#  created_at                                           :datetime         not null
#  updated_at                                           :datetime         not null
#  number                                               :string
#  source                                               :string
#  status                                               :string
#  confirmed                                            :boolean
#  driver_id                                            :bigint(8)
#  additional_driver_id                                 :bigint(8)
#  vehicle_id                                           :bigint(8)
#  tax_rate_id                                          :bigint(8)
#  notes                                                :text
#  pickup_location_id                                   :bigint(8)
#  pickup                                               :datetime
#  pickup_odometer                                      :bigint(8)
#  pickup_fuel                                          :float
#  drop_off_location_id                                 :bigint(8)
#  drop_off                                             :datetime
#  drop_off_odometer                                    :bigint(8)
#  drop_off_fuel                                        :float
#  collision_damage_waiver                              :boolean
#  driver_financial_responsibility_signature            :text
#  additional_driver_financial_responsibility_signature :text
#  driver_signature                                     :text
#  additional_driver_signature                          :text
#

require 'spec_helper'
require 'factories/rentals'

describe Rental do

  describe '.in_between' do

    let(:rental) { create(:rental, pickup: Date.new(2018, 1, 6), drop_off: Date.new(2018, 1, 9)) }

    it 'returns rental between a date' do
      rental

      results = Rental.in_between(rental.pickup + 1.day)

      expect(results.count).to eq(1)
      expect(results).to include(rental)
    end

    it 'returns empty array if no date' do
      rental

      results = Rental.in_between(rental.drop_off + 10.days)

      expect(results.count).to eq(0)
    end
  end
end
