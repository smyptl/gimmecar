# == Schema Information
#
# Table name: drivers
#
#  id                      :integer          not null, primary key
#  first_name              :string
#  last_name               :string
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
#

class Driver < ApplicationRecord

  has_many :rentals

  has_one :current_insurance_policy

  def name
    "#{first_name} #{last_name}"
  end

  def do_not_rent?
    do_not_rent
  end
end
