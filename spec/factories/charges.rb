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

FactoryBot.define do

  factory :charge do

  end
end
