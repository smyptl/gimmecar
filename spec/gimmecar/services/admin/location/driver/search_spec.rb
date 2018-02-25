require 'spec_helper'
require 'factories/drivers'

describe Services::Admin::Location::Drivers::Search do

  describe '#retrieve!' do
    it 'returns driver object that matches name' do
      driver = create(:driver)
      5.times { create(:driver) }

      results = Services::Admin::Location::Drivers::Search.new(
        date_of_birth: driver.date_of_birth,
        name_first: driver.name_first,
        name_last: driver.name_last,
      ).retrieve!

      expect(results).to_not          eq(nil)
      expect(results[:id]).to         eq(driver.id)
      expect(results[:name_first]).to eq(driver.name_first)
      expect(results[:name_last]).to  eq(driver.name_last)
    end
  end
end
