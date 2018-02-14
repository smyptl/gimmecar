require 'spec_helper'

describe Lib::Services::Builder do

  describe '.output' do
    it 'fetches a id accurately' do
      output = Lib::Services::Builder.component do |o|
        o.id(:number)
      end

      expect(output[:attributes]).to eq({
        :id => {
          :name    => :id,
          :type    => :value,
          :options => { :as => :number },
        }
      })
    end

    it 'fetches values accurately' do
      output = Lib::Services::Builder.component do |o|
        o.values [:one, :two], if: -> (f) { f.test }
      end

      output = output[:attributes]

      expect(output).to have_key(:one)
      expect(output).to have_key(:two)
      expect(output[:one][:options]).to include(:if)
    end
  end
end
