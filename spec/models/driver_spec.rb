# == Schema Information
#
# Table name: drivers
#
#  id                      :bigint(8)        not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  gender                  :string
#  date_of_birth           :date
#  license_number          :string
#  license_state           :string
#  license_country         :string
#  license_expiration_date :date
#  do_not_rent             :boolean
#  stripe_id               :string
#  notes                   :text
#  name_first              :string
#  name_middle             :string
#  name_last               :string
#

require 'spec_helper'
require 'factories/drivers'
require 'factories/rentals'

describe Driver do

  describe '.destroy' do
    it 'cannot destroy if rental as driver' do
      driver = create(:driver)
      create(:rental, driver: driver)

      expect(Driver.count).to eq(1)
      driver.destroy

      expect(Driver.count).to eq(1)
    end

    it 'cannot destroy if rental as additional_driver' do
      additional_driver = create(:driver)
      create(:rental, additional_driver: additional_driver)

      expect(Driver.count).to eq(2)
      additional_driver.destroy

      expect(Driver.count).to eq(2)
    end

    it 'destroys driver if no rental' do
      driver = create(:driver)
      expect(Driver.count).to eq(1)

      driver.destroy
      expect(Driver.count).to eq(0)
    end
  end

  describe '.search' do
    it 'returns results of drivers' do
      driver_1 = create(:driver)
      driver_2 = create(:driver)

      result = Driver.search(name: driver_1.name_first.upcase, date_of_birth: driver_1.date_of_birth)

      expect(result).to eq(driver_1)
    end
  end

  describe '#rentals' do
    it 'finds rental as driver primary' do
      driver = create(:driver)
      rental = create(:rental, driver: driver)
      create(:rental)

      expect(driver.rentals).to contain_exactly(rental)
    end

    it 'finds rental as driver additional' do
      driver = create(:driver)
      rental = create(:rental, additional_driver: driver)

      expect(driver.rentals).to contain_exactly(rental)
    end
  end

  describe '#rentals_closed' do
    it 'returns closed rental as additional driver' do
      driver = create(:driver)
      rental = create(:rental, :closed, additional_driver: driver)

      expect(driver.rentals_closed).to contain_exactly(rental)
    end
  end

  describe '#retrieve_or_create_stripe_customer' do
    it 'retrieves customer' do
      driver = create(:driver, create_stripe_id: true)
      stripe_id = driver.stripe_id
      driver.retrieve_or_create_stripe_customer
      driver = Driver.find(driver.id)
      expect(driver.stripe_id).to eq(stripe_id)
    end

    it 'creates customer' do
      driver = create(:driver)
      expect(driver.stripe_id).to eq(nil)
      driver.retrieve_or_create_stripe_customer
      driver = Driver.find(driver.id)
      expect(driver.stripe_id).to_not eq(nil)
    end
  end
end
