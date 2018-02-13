require 'spec_helper'
require 'factories/drivers'

describe Lib::Services::Generator do

  describe '#fetch' do

    it 'returns generated hash' do
      create(:driver)

      results = Services::Command::Drivers.fetch!

      expect(results['object']).to eq(:list)
      expect(results['count']).to eq(1)
      expect(results['data']).to eq(nil)
    end
  end
end
