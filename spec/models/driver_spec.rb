require 'spec_helper'
require 'factories/drivers'
require 'factories/rentals'

describe Driver do

  describe '.destroy' do

    it 'cannot destroy if rental' do
      driver = create(:driver)
      expect(Driver.count).to eq(1)
      driver.rentals << create(:rental)
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
end
