require 'spec_helper'
require 'factories/drivers'

describe Lib::Services::Base do

  describe '#retrieve' do

    it 'returns appropriate hash' do
      test_service = Class.new(Lib::Services::Base) do
        output do
          collection :drivers do |c|
          end
        end

        def query
          Driver.all
        end
      end

      driver = create(:driver)

      results = test_service.retrieve!

      expect(results[:object]).to eq(:list)
      expect(results[:count]).to eq(1)
      expect(results[:data].count).to eq(1)
    end
  end
end
