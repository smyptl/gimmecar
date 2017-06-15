# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  first_name        :string
#  last_name         :string
#  email             :string
#  password_digest   :string
#  active            :boolean          default(FALSE)
#  confirmed         :boolean          default(FALSE)
#  persistence_token :string
#  perishable_token  :string
#

FactoryGirl.define do

  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.email
    password '1234'
    password_confirmation '1234'
  end
end
