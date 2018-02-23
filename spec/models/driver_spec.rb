# == Schema Information
#
# Table name: drivers
#
#  id                      :integer          not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  gender                  :string
#  address_1               :string
#  address_2               :string
#  city                    :string
#  state                   :string
#  zip_code                :string
#  country                 :string
#  home_phone_number       :string
#  cell_phone_number       :string
#  email                   :string
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
    it 'cannot destroy if rental' do
      driver = create(:driver)
      create(:rental, driver: driver)

      expect(Driver.count).to eq(1)
      driver.destroy

      expect(Driver.count).to eq(1)
    end

    it 'destroys driver if no rental' do
      driver = create(:driver)
      expect(Driver.count).to eq(1)

      driver.destroy
      expect(Driver.count).to eq(0)
    end
  end

  #describe '.search' do
    #it 'returns results of drivers' do
      #driver_1 = create(:driver)
      #driver_2 = create(:driver)

      #results = Driver.search(name: driver_1.name_first)

      #expect(results.count).to eq(1)
    #end
  #end
end
