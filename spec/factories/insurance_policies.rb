# == Schema Information
#
# Table name: insurance_policies
#
#  id                 :bigint(8)        not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint(8)
#  driver_id          :bigint(8)
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

FactoryBot.define do
  factory :insurance_policy do
    company_name Faker::Company.name
    agent Faker::Name.name
    policy_number SecureRandom.hex(10)
    phone_number "9091231234"
    effective_date (Time.current - 6.months).to_date
    expiration_date (Time.current + 6.months).to_date

    verify_date (Time.current).to_date
    verify_agent Faker::Name.name
    verify_call_center Faker::Address.city
  end
end
