# == Schema Information
#
# Table name: emails
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_type :string
#  owner_id   :bigint(8)
#  email_type :string
#  email      :string
#  notes      :text
#  primary    :boolean          default(FALSE)
#

FactoryBot.define do

  factory :email do
    email { Faker::Internet.email }
  end
end
