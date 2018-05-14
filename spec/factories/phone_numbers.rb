# == Schema Information
#
# Table name: phone_numbers
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_type :string
#  owner_id   :bigint(8)
#  phone_type :string
#  number     :string
#  extension  :string
#  notes      :text
#  primary    :boolean          default(FALSE)
#

FactoryBot.define do

  factory :phone_number do
    phone_type :cell
    number 1231231234
    extension 1231

    trait :primary do
      primary true
    end
  end
end
