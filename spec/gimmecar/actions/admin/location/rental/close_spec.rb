require 'spec_helper'
require 'factories/rentals'

describe Actions::Admin::Location::Rental::Close do
  describe 'validations' do
    it 'drop_off_odometer cannot be less than pickup_odometer' do
      pickup_odometer = 10
      rental          = create(:rental, pickup_odometer: pickup_odometer)
      failure         = double(:failure)

      expect(failure).to receive(:call)

      action = Actions::Admin::Location::Rental::Close.new({ drop_off_odometer: pickup_odometer - 1 })
      action.execute(nil, failure, { number: rental.number })

      expect(action.errors[:drop_off_odometer]).to eq(['must be greater than pickup odometer'])
    end

    it 'drop_off cannot be before than pickup' do
      pickup  = Time.current - 1.day
      rental  = create(:rental, pickup: pickup)
      failure = double(:failure)

      expect(failure).to receive(:call)

      action = Actions::Admin::Location::Rental::Close.new({ drop_off: pickup - 10.days })
      action.execute(nil, failure, { number: rental.number })

      expect(action.errors[:drop_off]).to eq(['must be after pickup'])
    end
  end
end
