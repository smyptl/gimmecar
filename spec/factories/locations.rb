# == Schema Information
#
# Table name: locations
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  name         :string
#  slug         :string
#  latitude     :string
#  longitude    :string
#  address_1    :string
#  address_2    :string
#  city         :string
#  state        :string
#  zip_code     :string
#  country      :string
#  phone_number :string
#

FactoryGirl.define do

  factory :location do
    name 'Hotel California'
    slug { Faker::Internet.slug(name, '-') }
  end
end
