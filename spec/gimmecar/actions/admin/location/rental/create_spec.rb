require 'spec_helper'

describe Actions::Admin::Location::Rental::Create do

  describe '#save' do
    it 'saves driver, insurance policy, rental' do
      driver = attributes_for(:driver)
      driver[:insurance] =


      action = Actions::Admin::Location::Rental::Create.new({
        :pickup                => DateTime.now,
        :drop_off              => DateTime.now + 2.days,
        :driver                => driver,
        :add_additional_driver => false,
      })
    end
  end
end
