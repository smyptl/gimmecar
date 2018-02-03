require 'spec_helper'

describe Lib::Services::Generator do

  describe '.output' do
    it 'fetches a id accurately' do
      output = Lib::Services::Generator.output do |o|
        o.id(:number)
      end

      expect(output).to eq({
        :id => {
          :type => :value,
          :options => { :as => :number },
        }
      }.with_indifferent_access)
    end

    it 'fetches values accurately' do
      output = Lib::Services::Generator.output do |o|
        o.values [:one, :two], if: -> (f) { f.test }
      end

      expect(output).to have_key(:one)
      expect(output).to have_key(:two)
      expect(output[:one][:options]).to include(:if)
    end
  end
end
