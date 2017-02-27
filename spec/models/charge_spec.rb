# == Schema Information
#
# Table name: charges
#
#  id               :integer          not null, primary key
#  owner_type       :string
#  owner_id         :integer
#  stripe_charge_id :string
#  details          :json
#  sub_total        :integer
#  discount         :json
#  fees             :json
#  tax_rate         :decimal(10, 4)
#  decimal          :decimal(10, 4)
#  tax              :integer
#  total            :integer
#  deposit          :boolean          default(FALSE)
#

require 'spec_helper'
require 'helpers/stripe_helper'

describe Charge do

  describe '#execute' do
    it 'calls success and returns self' do
      charge = Charge.new({
        :total => 1400,
      })

      success = double(:success)
      failure = double(:failure)

      expect(success).to receive(:call)

      charge.execute(success, failure, create_customer: true, token: create_valid_credit_card_token_id)

      expect(Charge.all.count).to eq(0)
    end

    it 'calls failure to prepaid card' do
      charge = Charge.new({
        :total => 1400,
      })

      success = double(:success)
      failure = double(:failure)

      expect(failure).to receive(:call).with({ message: "Your card's security code is incorrect.", customer_id: nil })

      charge.execute(success, failure, create_customer: true, token: create_invalid_credit_card_token_id(:cvc))
    end

    it 'calls failure, card attached to customer but no charge' do
      charge = Charge.new({
        :total => 1400,
      })

      success = double(:success)
      failure = double(:failure)

      expect(failure).to receive(:call).with(hash_including({ message: "Your card was declined." }))

      charge.execute(success, failure, create_customer: true, token: create_invalid_credit_card_token_id(:charge_failure))
    end
  end
end
