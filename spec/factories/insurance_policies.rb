# == Schema Information
#
# Table name: insurance_policies
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  driver_id          :integer
#  company_name       :string
#  agent              :string
#  policy_number      :string
#  phone_number       :string
#  effective_date     :date
#  expiration_date    :date
#  verify_date        :date
#  verify_agent       :string
#  verify_call_center :string
#

FactoryGirl.define do
  factory :insurance_policy do
    confirmation_date Date.today
    company_name Faker::Company.name
    agent Faker::Name.name
    policy_number SecureRandom.hex(10)
    phone_number Faker::PhoneNumber.phone_number
    effective_date Date.today - 6.months
    expiration_date Date.today + 6.months

    verify_date Date.today
    verify_agent Faker::Name.name
    verify_call_center Faker::Address.city
  end
end
