# == Schema Information
#
# Table name: charges
#
#  id               :integer          not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_type       :string
#  owner_id         :integer
#  stripe_charge_id :string
#  amount           :integer
#  deposit          :boolean          default(FALSE)
#
require 'helpers/stripe_helper'

FactoryBot.define do

  factory :charge do

    trait :create_stripe_charge do
      before(:create) do |instance|
        instance.stripe_charge_id = create_charge(amount: instance.amount)['id']
      end
    end
  end
end
