# == Schema Information
#
# Table name: drivers
#
#  id                      :integer          not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  gender                  :string
#  address_1               :string
#  address_2               :string
#  city                    :string
#  state                   :string
#  zip_code                :string
#  country                 :string
#  home_phone_number       :string
#  cell_phone_number       :string
#  email                   :string
#  date_of_birth           :date
#  license_number          :string
#  license_state           :string
#  license_country         :string
#  license_expiration_date :date
#  do_not_rent             :boolean
#  stripe_id               :string
#  notes                   :text
#  name_first              :string
#  name_middle             :string
#  name_last               :string
#

FactoryBot.define do
  factory :driver do
    name_first { Faker::Name.first_name }
    name_middle { Faker::Name.last_name }
    name_last { Faker::Name.last_name }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip_code { Faker::Address.zip_code }
    country { Faker::Address.country }
    cell_phone_number '9091231234'
    home_phone_number '9091239021'
    gender { ['male', 'female'].sample }
    email { Faker::Internet.email }
    date_of_birth (Time.current - 26.years).to_date
    license_number { Faker::Number.number(7) }
    license_state { state }
    license_country { country }
    license_expiration_date (Time.current + 1.year).to_date
  end
end
