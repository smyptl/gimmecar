# == Schema Information
#
# Table name: addresses
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_type   :string
#  owner_id     :bigint(8)
#  address_type :string
#  street1      :string
#  street2      :string
#  city         :string
#  state        :string
#  zip_code     :string
#  notes        :text
#  primary      :boolean          default(FALSE)
#

FactoryBot.define do

  factory :address do
    address_type :home
    street1      { Faker::Address.street_address }
    street2      { Faker::Address.secondary_address }
    city         { Faker::Address.city }
    state        { Faker::Address.state }
    zip_code     { rand(10000..99999).to_s }

    trait :primary do
      primary true
    end
  end
end
