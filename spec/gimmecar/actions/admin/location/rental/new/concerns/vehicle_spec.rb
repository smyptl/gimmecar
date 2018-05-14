require 'spec_helper'

describe Actions::Admin::Location::Rental::New::Concerns::Vehicle do

  let(:klass) do
    klass = class FakeKlass < Lib::Actions::Base
      include Actions::Admin::Location::Rental::New::Concerns::Vehicle
    end

    klass.define_method :vehicle do
      OpenStruct.new(odometer: 10)
    end

    klass.define_method :available_vehicle_ids do
      [1]
    end

    klass
  end

  describe '#valid?' do
    it 'returns error if pickup odometer than last vehicle odometer' do
      action = klass.new(vehicle_id: 1, pickup_odometer: 9)
      action.valid?

      expect(action.errors[:pickup_odometer]).to eq(['must be greater than 10'])
    end

    it 'if no vehicle id, does not return error' do
      action = klass.new(pickup_odometer: 10, vehicle_id: nil)
      action.valid?

      expect(action.errors[:pickup_odometer].empty?).to eq(true)
      expect(action.errors[:vehicle_id].empty?).to eq(false)
    end
  end
end
