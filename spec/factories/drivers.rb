# == Schema Information
#
# Table name: drivers
#
#  id                      :integer          not null, primary key
#  title                   :string
#  first_name              :string
#  last_name               :string
#  name                    :string
#  gender                  :string
#  address_1               :string
#  address_2               :string
#  city                    :string
#  state                   :string
#  zip_code                :string
#  country                 :string
#  home_phone_number       :integer
#  cell_phone_number       :integer
#  email                   :string
#  date_of_birth           :date
#  license_number          :string
#  license_state           :string
#  license_country         :string
#  license_expiration_date :date
#  do_not_rent             :boolean
#  stripe_id               :string
#  notes                   :text
#

FactoryGirl.define do
  factory :driver do

  end
end
